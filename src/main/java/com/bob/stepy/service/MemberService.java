package com.bob.stepy.service;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.*;
import java.nio.channels.Channels;
import java.nio.channels.FileChannel;
import java.nio.channels.ReadableByteChannel;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Random;

import javax.imageio.ImageIO;
import javax.mail.*;
import javax.mail.PasswordAuthentication;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bob.stepy.dao.MemberDao;
import com.bob.stepy.dto.FileUpDto;
import com.bob.stepy.dto.MemberDto;
import com.bob.stepy.dto.MemberKaKaoTokenDto;
import com.bob.stepy.dto.MemberKakaoProfileDto;
import com.bob.stepy.dto.MessageDto;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class MemberService {

	static String restApi = "3a7921c9c86e805003cd07a8e548f149";
	static String redirect_uri= "http://localhost/stepy/kakaoLogInProc";

	@Autowired
	private MemberDao mDao;
	@Autowired
	private HttpSession session;
	
	private ModelAndView mv;

	//_______________



	public String mKakaoAutho() {

		String kakaoUrl = "https://kauth.kakao.com/oauth/authorize?" + "client_id=" + restApi + "&redirect_uri=" + redirect_uri + "&response_type=code"; 
		return kakaoUrl;
	}



	public String mKakaoLogInProc(String code,RedirectAttributes rttr) {

		String path;
		RestTemplate rt = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.add( "Content-type", "application/x-www-form-urlencoded;charset=utf-8");

		MultiValueMap<String,String>params = new LinkedMultiValueMap<>();
		params.add("grant_type", "authorization_code");
		params.add("client_id", restApi);
		params.add("redirect_uri", redirect_uri);
		params.add("code", code);

		HttpEntity<MultiValueMap<String,String>> kakaoTokenRequest = 
				new HttpEntity<>(params, headers);

		ResponseEntity<String> response = rt.exchange(
				"https://kauth.kakao.com/oauth/token",
				HttpMethod.POST,
				kakaoTokenRequest,
				String.class
				);


		ObjectMapper objectMapper = new ObjectMapper();
		MemberKaKaoTokenDto tokenDto = null;

		try {
			tokenDto = objectMapper.readValue(response.getBody(), MemberKaKaoTokenDto.class);
		} catch (JsonMappingException e) {
			e.printStackTrace();
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}

		System.out.println("Get access token for kakato : "+tokenDto.getAccess_token());

		MemberDto member = mKakaoProfileRequest(tokenDto);

		if(member.getM_email().equals("no_email_detected")) {
			rttr.addFlashAttribute("msgforlogin", "eamil 정보수집에 동의해주세요");
			//로그아웃처리 

			mKakaoDisconnect(tokenDto.getAccess_token());
			return "redirect:mLoginFrm";
		}

		session.setAttribute("member", member);

		return "redirect:/";
	}



	@Transactional
	public MemberDto mKakaoProfileRequest(MemberKaKaoTokenDto tokenDto) {


		RestTemplate rt = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.add("Authorization", "Bearer "+tokenDto.getAccess_token());
		headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

		HttpEntity<MultiValueMap<String,String>> kakaoProfileRequest = 
				new HttpEntity<>(headers);

		ResponseEntity<String> response = rt.exchange(
				"https://kapi.kakao.com/v2/user/me",
				HttpMethod.POST,
				kakaoProfileRequest,
				String.class
				);


		ObjectMapper objectMapper = new ObjectMapper();
		MemberKakaoProfileDto kakaoProfile = null;

		try {
			kakaoProfile = objectMapper.readValue(response.getBody(), MemberKakaoProfileDto.class);

		} catch (JsonMappingException e) {
			e.printStackTrace();
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}


		System.out.println("kakao Id : "+kakaoProfile.getId());
		System.out.println("kakao email : "+kakaoProfile.getKakao_account().getEmail());
		System.out.println("The format of user id fot stepy is "+kakaoProfile.getKakao_account().getEmail()+"_"+kakaoProfile.getId());
		System.out.println("The format of user enamil for stepy is "+kakaoProfile.getKakao_account().getEmail());
		System.out.println("Nickname and user name have the same value for deafult set");


		String idPreCheck = kakaoProfile.getKakao_account().getEmail()+"_"+kakaoProfile.getId();
		String dbCheckResult = mIdDuplicationCheck(idPreCheck);
		MemberDto memberDto = new MemberDto();

		if(kakaoProfile.getKakao_account().getEmail() == "" || kakaoProfile.getKakao_account().getEmail() == null) {
			memberDto.setM_email("no_email_detected");
			System.out.println("emial null is detected");
			System.out.println("email null memberDto is : "+ memberDto);
			return memberDto;
		}

		if(dbCheckResult == "0") {
			memberDto.setM_id(kakaoProfile.getKakao_account().getEmail()+"_"+kakaoProfile.getId());
			memberDto.setM_email(kakaoProfile.getKakao_account().getEmail());
			memberDto.setM_name(kakaoProfile.getKakao_account().getProfile().getNickname());
			memberDto.setM_nickname(kakaoProfile.getKakao_account().getProfile().getNickname());
			memberDto.setM_pwd("mustbekeptwithoutanyleak11!!");//default password for users who logged in from kakaotalk
		
			try {
				mJoinProc(memberDto);
				mKakaoProfileUp(kakaoProfile);
	
			}catch(Exception e){
				System.out.println("mKakaoProfileRequest Member insult failure" );
			}

		}
		else {
			memberDto = mDao.getMemeberInfo(idPreCheck);
			
			System.out.println("alread singed up member : "+memberDto);
			
		}


		return memberDto;
	}


	public void mKakaoDisconnect(String accessToken) {

		RestTemplate rt = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.add("Authorization", "Bearer "+accessToken);

		HttpEntity<MultiValueMap<String,String>> forDisconnection = 
				new HttpEntity<>(headers);


		ResponseEntity<String> response = rt.exchange(
				
				"https://kapi.kakao.com/v1/user/unlink",
				HttpMethod.POST,
				forDisconnection,
				String.class
				);

		System.out.println(response.getBody());



	}

	@Transactional
	public void mKakaoProfileUp(MemberKakaoProfileDto profile) throws IOException{

		String imageUrl = profile.getProperties().getProfile_image();
		String userid = profile.getKakao_account().getEmail()+"_"+profile.getId();
		URL url = new URL(imageUrl);


		String dirpath = session.getServletContext().getRealPath("/");
		dirpath += "resources/profile/";

		File dir = new File(dirpath);
		if(dir.isDirectory() == false) {
			dir.mkdir();
		}

		String sourcefileName = url.getFile();
		String sysName = System.currentTimeMillis() + sourcefileName.substring(sourcefileName.lastIndexOf("."));
		System.out.println("sysName is : "+sysName);
		String oriName = profile.getId() +"_"+ sourcefileName.substring(sourcefileName.lastIndexOf("/")+1);
		String fileName = dirpath + oriName;
		System.out.println("file path is : " + fileName);
		ReadableByteChannel readChannel = Channels.newChannel(url.openStream());

		FileOutputStream fileOS = new FileOutputStream(fileName);
		FileChannel writeChannel = fileOS.getChannel();
		
		writeChannel.transferFrom(readChannel, 0, Long.MAX_VALUE);
		
		
		FileUpDto fileDto = new FileUpDto();
		fileDto.setF_oriname(oriName);
		fileDto.setF_sysname(sysName);
		fileDto.setF_mnum(userid);
		
		System.out.println(fileDto);
		
		mDao.mKakaoThumbUpload(fileDto);

	}



	// join stepy
	@Transactional
	public String mJoinProc(MemberDto member) {

		String path = null;
		String actualpwd;
		String realaddr = null;

		BCryptPasswordEncoder pwdEncrypt = new BCryptPasswordEncoder();

		actualpwd = pwdEncrypt.encode(member.getM_pwd());
		member.setM_pwd(actualpwd);


		if(member.getAddress_without_specific() != "" && member.getAddress_without_specific() != null ) {
			if(member.getAddress_with_specific() !="") {
				realaddr = member.getAddress_without_specific() +" "+ member.getAddress_with_specific();
				member.setM_addr(realaddr);
			}
			else if(member.getAddress_with_specific()== ""){
				realaddr = member.getAddress_without_specific();
				member.setM_addr(realaddr);
			}
		}

		try {
			
			mOnceCreateProfil();
			
			mDao.memberInsert(member);
			
			String sysName = System.currentTimeMillis() + "_profile.png";
			String oriName = "stepydefaultprofile.png";
			
			FileUpDto fileDto = new FileUpDto();
			fileDto.setF_oriname(oriName);
			fileDto.setF_sysname(sysName);
			fileDto.setF_mnum(member.getM_id());
				
			mDao.mThumbUpload(fileDto);
		
			path="redirect:/";
		}catch(Exception e) {
			path="redirect:mJoinFrm";
			e.printStackTrace();
		}

		return path;
	}


	private void mOnceCreateProfil() {

		String dirpath = session.getServletContext().getRealPath("/");
		String loadpath = dirpath + "resources/images/";
		String destpath = dirpath + "resources/profile/";

		File fork = new File(destpath + "stepydefaultprofile.png");
		if (fork.exists()) {
			
			System.out.println("already existing file");	
			return;
		}
		File dir = new File(destpath);
		if(dir.isDirectory() == false) {
			dir.mkdir();
			System.out.println("Created profile folder ");
		}
		
		File folderInput = new File(loadpath+"stepydefaultprofile.png");
		try {
			BufferedImage image = ImageIO.read(folderInput);
			ImageIO.write(image, "png", fork);
		} catch (IOException e) {
			e.printStackTrace();
		}

		return;
	}



	public String mIdDuplicationCheck(String tempid) {

		String msg;

		int i = mDao.duplicationCheck(tempid);
		if (i == 1) {
			msg="1";
			//"이미 존재하는 아이디입니다. 다른 아이디를 선택해주세요 (already existing id. select another, please)";
		}else {
			msg = "0";
			//"사용가능한 아이디입니다. (usable id)";
		}

		return msg;

	}


	public String mLoginProc(MemberDto member, RedirectAttributes rttr) {

		String path;
		String encryptPass = mDao.getEncryptizedPass(member.getM_id());

		BCryptPasswordEncoder pwdEncoder = new BCryptPasswordEncoder();		
		
		if(encryptPass != null) {
			if(pwdEncoder.matches(member.getM_pwd(), encryptPass)) {

				member = mDao.getMemeberInfo(member.getM_id());
				session.setAttribute("member", member);
				path = "redirect:/";
							
				
			}else {
				// right id, but pass typo
				path="redirect:mLoginFrm";
				rttr.addFlashAttribute("loginMsg", "비밀번호 입력 오류");
				rttr.addFlashAttribute("resultNum", "1");
			}

		}else {
			//no memberinfo exist
			path="redirect:mLoginFrm";
			rttr.addFlashAttribute("loginMsg", "존재하지 않는 아이디입니다.");
			rttr.addFlashAttribute("resultNum", "2");
		}

		return path; 
	}


	public String mLogoutProc() {

		session.invalidate();

		return "home";
	}



	public ModelAndView mMyPage() {
		
		MemberDto member = (MemberDto)session.getAttribute("member");
		System.out.println(member);
		String userid = member.getM_id();
		mv = new ModelAndView();
		
		// 아 생각해보니까 이거 위험한데, 절대절대절대, 파일업로드할때 프로필 사진 아닌 이상 회원 아이디로 외래키 넣기 없는걸로. 
		FileUpDto profile = mDao.mGetProfile(userid);
		System.out.println(profile);
		mv.addObject("profile", profile);
		mv.setViewName("mMyPage");
		
		return mv;
	}



	public Map<String, String> mAuthMail(String mailaddr) {
		
		Map<String, String> map = new HashMap<>();
		
		if(mailaddr.contains("@naver.com") || mailaddr.contains("@gmail.com")) {

			final String user = "stepy.tester@gmail.com";
			final String password = "stepy1234!";
			final String host ="smtp.gmail.com";// "smtp.naver.com";
			int port = 587;
			final String to = mailaddr;

			Properties prop = new Properties();

			prop.put("mail.smtp.auth", "true");
			prop.put("mail.smtp.starttls.enable","true");
			prop.put("mail.smtp.host", host);
			prop.put("mail.smtp.port", port);
			
			Session mailsession = Session.getInstance(prop, 
					new javax.mail.Authenticator() {
					protected PasswordAuthentication getPasswordAuthentication() {
						return new PasswordAuthentication(user, password);
					}
			});
			
			
			//random
			Random random = new Random();
			String authkey = "";
			
			for(int i = 0; i<3 ; i++) {
				int rand_char = random.nextInt(26)+65;
				authkey += (char)rand_char;
			}
			
			int rand_int = random.nextInt(9000)+1000 ;
			authkey += rand_int;
			
			try {
				Message message = new MimeMessage(mailsession);
				message.setFrom(new InternetAddress(user));
				message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
				message.setSubject("STEPY 회원가입 인증메일입니다");
				message.setText("인증번호를 입력해주세요\n"+authkey);
				Transport.send(message);
				System.out.println("Sent a key , which is : " + authkey);
			}catch(Exception e) {
				throw new RuntimeException(e);
			}
			
			map.put("msg","메일함에서 인증번호를 확인해주세요." );
			map.put("authkey",authkey);
				
		}else {
			map.put("msg","지원하지 않는 이메일 형식입니다. naver 혹은 google 메일을 사용해주세요.");
		}
		
		return map;
		
	}



	@Transactional
	public ModelAndView mModifyMyinfo() {
		
		mv = new ModelAndView();
		MemberDto member = (MemberDto)session.getAttribute("member");
		FileUpDto profile = mDao.mGetProfile(member.getM_id());
		
		mv.addObject("profile", profile);
		mv.setViewName("mModifyMyinfo");
		
		return mv;
		
	}
	


	public ModelAndView mMyLittleBlog(String blog_id) {
		
		mv = new ModelAndView();
		
		FileUpDto profile = mDao.mGetProfile(blog_id);
		mv.addObject("hostprofile", profile);
		MemberDto member = mDao.getMemeberInfo(blog_id);
		mv.addObject("hostaccount", member);
		
		return mv;
	}


	private void mShutFirstMsg(String m_id) {
		
		MessageDto msg = new MessageDto();
		
		msg.setMs_mid(m_id);
		msg.setMs_smid("admin");
		msg.setMs_contents("안녕하세요! Stepy와 함께 전국 방방 곳곳! 발도장을 찍어볼까요? 여행 일정을 짜고, 동행인을 구하고, 소통하고 즐겨봐요!");
		msg.setMs_bfread(1);
		msg.setMs_afread(0);
		
		mDao.mSetMessage(msg);
		
	}



	public ModelAndView mSendMessage(String toid, String fromid) {
		
		mv = new ModelAndView();

		MemberDto guest = mDao.getMemeberInfo(fromid);
		mv.addObject("guest", guest);
		
		MemberDto host = mDao.getMemeberInfo(toid);
		mv.addObject("host", host);
		
		return mv;
	}


	@Transactional
	public String mSendMessageProc(MessageDto msg, RedirectAttributes rttr) {
		
		mv = new ModelAndView();
		
		String ms_mid = msg.getMs_mid();
		String ms_smid = msg.getMs_smid();
		MessageDto before = mDao.mGetBfMsg(ms_mid);

		if(before == null) {
			msg.setMs_bfread(1);
			msg.setMs_afread(0);
			mDao.mSetMessage(msg);
			
		}else {
			msg.setMs_bfread(before.getMs_bfread()+1);
			msg.setMs_afread(before.getMs_afread());

			mDao.mSetMessage(msg);
		}
		

		rttr.addAttribute("ms_smid", ms_smid);
		
		//List<MessageDto> smList = mDao.mGetMsgList(ms_mid);
		//MessageDto md1 = smList.get(0);
		//System.out.println(md1);
		
		return "redirect:mMeSendOverview";
	}



	public ModelAndView mMeSendOverview(String ms_smid) {
		
		mv = new ModelAndView();
		List<MessageDto> smList = mDao.mGetSendList(ms_smid);
		mv.addObject("smList", smList);
		mv.setViewName("mMeSendOverview");
		
		return mv;
	}



	public ModelAndView mReceiveOverview(String hostid) {

		mv = new ModelAndView();
		List<MessageDto> rmList = mDao.mGetReceiveList(hostid);
		mv.addObject("rmList", rmList);
		mv.setViewName("mReceiveOverview");
		
		return mv;
	}



	public MessageDto mNewMsgCount(String ms_mid) {
		
		 MessageDto fork = mDao.mGetBfMsg(ms_mid);
		 MessageDto msg = new MessageDto();
		 if(fork == null) {
			 msg.setMs_bfread(0);
			 msg.setMs_afread(0);
			 System.out.println("hope no problem" + msg);
		 }
		 
		return msg;
	}



	public void mUploadAfterView(String ms_mid) {
		
		MessageDto msg = mDao.mGetBfMsg(ms_mid);
		if(msg == null) {
			return;
		}else {
			mDao.mUploadAfterView(msg);
		}

		return;
	}






}
