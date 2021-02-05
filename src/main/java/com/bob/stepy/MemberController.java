package com.bob.stepy;

import java.util.Enumeration;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bob.stepy.dto.MemberDto;
import com.bob.stepy.dto.MessageDto;
import com.bob.stepy.dto.ReplyDto;
import com.bob.stepy.service.MemberService;

import lombok.extern.java.Log;
import oracle.jdbc.proxy.annotation.Post;



@Controller
@Log
public class MemberController {

	static String restApi = "3a7921c9c86e805003cd07a8e548f149";
	static String redirect_uri= "http://localhost/stepy/kakaoLogInProc";
	private static final Logger logger = LoggerFactory.getLogger(MemberController.class);


	@Autowired
	private MemberService mServ;

	private ModelAndView mv;

	
	@ResponseBody
	@GetMapping(value="mUploadAfterView", produces = "application/text; charset=utf-8")
	public String mUploadAfterView(String ms_mid){
		
		mServ.mUploadAfterView(ms_mid);
		
		return "success";
	}
	
	@ResponseBody
	@GetMapping(value="mNewMsgCount", produces = "application/json; charset=utf-8")
	public MessageDto mNewMsgCount(String ms_mid){
		
		MessageDto msg = mServ.mNewMsgCount(ms_mid);
		
		return msg;
	}

	@GetMapping("mReceiveOverview")
	public ModelAndView mReceiveOverview(String hostid) {

		mv = mServ.mReceiveOverview(hostid);

		return mv;
	}

	@GetMapping("mMeSendOverview")
	public ModelAndView mMeSendOverview(String ms_smid) {

		mv = mServ.mMeSendOverview(ms_smid);

		return mv;
	}

	@PostMapping("mSendMessageProc")//이걸...보낸메일 받은 메일 이렇게 구분할까 . 그럼 보낸메일부분에 보내주면 되겠네 redirect 로. 
	public String mSendMessageProc(MessageDto msg, RedirectAttributes rttr) {

		String path = mServ.mSendMessageProc(msg, rttr);

		return path;
	}

	@GetMapping("mSendMessage")
	public ModelAndView mMessage(String toid, String fromid) {

		mv = mServ.mSendMessage(toid, fromid);

		return mv;
	}

	@GetMapping("mMyLittleBlog")
	public ModelAndView mMyLittleBlog(String blog_id) {

		mv = mServ.mMyLittleBlog(blog_id);

		return mv;
	}




	@GetMapping("mMyTravleSchedule")
	public String mMyTravelSchedule() {

		return "mMyTravleSchedule";
	}

	@GetMapping("mMyLikedPages")
	public String mMyLikedPages() {

		return "mMyLikedPages";
	}

	@GetMapping("mMyCartPages")
	public String mMyCartPages() {

		return "mMyCartPages";
	}

	@GetMapping("mModifyMyinfo")
	public ModelAndView mModifyMyinfo() {

		mv = mServ.mModifyMyinfo();

		return mv; 
	}

	@ResponseBody
	@PostMapping(value = "mAuthMail", produces = "application/json; charset=utf-8")
	public Map<String, String> mAuthMail(String mailaddr) {

		Map<String, String> map = mServ.mAuthMail(mailaddr);

		return map;
	};

	@GetMapping("mMyPage")
	public ModelAndView mMyPage() {

		mv = mServ.mMyPage();

		return mv;
	}

	@GetMapping("mLogoutProc")
	public String mLogoutProc() {

		return mServ.mLogoutProc();
	}

	@PostMapping("mLoginProc")
	public String mLoginProc(MemberDto member, RedirectAttributes rttr) {
		logger.info("mLoginProc()");

		String path = mServ.mLoginProc(member, rttr);
		return path;
	}

	@GetMapping("mLoginFrm")
	public String mLoginFrm() {
		logger.info("mLoginFrm()");

		return "mLoginFrm";
	}


	@GetMapping(value = "mIdDuplicationCheck", produces = "application/text; charset=utf-8")
	@ResponseBody
	public String mIdDuplicationCheck(String tempid) {

		logger.info("mIdDuplicationCheck()");

		System.out.println(tempid);
		String id = mServ.mIdDuplicationCheck(tempid);
		System.out.println(id);

		return id;
	}



	@PostMapping("mJoinProc")
	public String mJoinProc(MemberDto member) {
		logger.info("mJoinProc()");

		String path = mServ.mJoinProc(member);

		return path;
	}


	@GetMapping("mJoinFrm")
	public String mJoinFrm() {
		logger.info("mJoinFrm()");

		return "mJoinFrm";
	}



	@GetMapping(value = "kakaoLogInProc", produces = "application/json; charset=utf8")
	public String kakaoLogInProc(String code,RedirectAttributes rttr) {

		String path = mServ.mKakaoLogInProc(code,rttr);

		return path;
	}


	@GetMapping("kakaoLogin")
	public String mGetAuthorizationUrl(RedirectAttributes rttr) { 

		String kakaoUrl = mServ.mKakaoAutho();

		return "redirect:"+kakaoUrl; 
	}


}
