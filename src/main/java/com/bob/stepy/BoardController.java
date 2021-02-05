package com.bob.stepy;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bob.stepy.dto.PostFileDto;
import com.bob.stepy.dto.ReplyDto;
import com.bob.stepy.service.BoardService;

import lombok.extern.java.Log;


@Controller
@Log
public class BoardController {
	
	@Autowired
	private BoardService bServ;
	

	private ModelAndView mv;
	

	
	
	@GetMapping("stepy")
	public String stepy() {
		log.info("stepy");
		
		return "home";
	}
	
	
	@GetMapping("bMateList")
	public ModelAndView bMateList(Integer pageNum) {
		log.info("bMateList()");
		
		mv = bServ.getBoardList(pageNum);
		
		return mv;
	}
	
	@GetMapping("bFreeList")
	public ModelAndView bFreeList(Integer pageNum) {
		log.info("bFreeList()");
		
		mv = bServ.getBoardList_2(pageNum);
		
		
		return mv;
	}
	
	@GetMapping("bReviewList")
	public ModelAndView bReviewList(Integer pageNum) {
		log.info("bReviewList()");
		
		mv = bServ.getBoardList_3(pageNum);
		
		return mv;
	}
	
	@GetMapping("bCommunity")
	public ModelAndView bCommunity(Integer pageNum){
		log.info("bCommunity()");
		
		mv = bServ.getBoardList_4(pageNum);
		
		return mv;
	}
	
	@GetMapping("contents")
	public ModelAndView postContents(Integer pnum) {
		log.info("postContets() - pnum : " + pnum);
		
		mv = bServ.getContents(pnum);
		
		return mv;
	}
	
	
	@GetMapping("bWriteProc")
	public String bWriteProc() {
		log.info("bWriteProc");
		
		return "bWriteProc";
	}
	
	@PostMapping("writDate")
	public String writDate(MultipartHttpServletRequest multi,
							RedirectAttributes rttr) {
		log.info("writDate()");
		
		String view = bServ.boardInsert(multi, rttr);
		
		
		return view;
	}
	//파일 다운로드
	@GetMapping("fileDown")
	public void fileDown(String sysName, HttpServletRequest requst,
			HttpServletResponse response) {
		log.info("fileDown file:" + sysName);
		bServ.fileDown(sysName, requst, response);
	}
	
	@GetMapping("bModifyFrm")
	public ModelAndView bModifyFrm(int pnum,
							RedirectAttributes rttr) {
		log.info("bModifyFrm pnum : " + pnum);
		
		mv = bServ.updateFrm(pnum, rttr);
		
		return mv;
	}
	
	@GetMapping("bSugModifyProc")
	public ModelAndView bSugModifyProc(int snum) {
		log.info("bSugModifyProc()");
		
		mv = bServ.sugupdate(snum);
		
		return mv;
	}
	
	@PostMapping("PostUpdate")
	public String PostUpdate(MultipartHttpServletRequest multi,
						RedirectAttributes rttr) {
		String view = bServ.PostUpdate(multi, rttr);
		
		return view;
	}
	
	@PostMapping("SugUpdate")
	public String SugUpdate(MultipartHttpServletRequest multi,
						RedirectAttributes rttr) {
		String view = bServ.SugUpdate(multi, rttr);
		
		return view;
	}
	
	
	@PostMapping(value = "delfile",
			produces = "application/json; charset=utf-8")
	@ResponseBody
	public Map<String, List<PostFileDto>> delFile(String sysname, int pnum){
		Map<String, List<PostFileDto>> rMap = null;
		
		rMap = bServ.fileDelete(sysname, pnum);
		
		return rMap;
	}
	
	@PostMapping(value = "replyIns",produces = "application/json; charset=utf-8")
	@ResponseBody
	public Map<String, List<ReplyDto>> replyIn(ReplyDto reply){
		Map<String, List<ReplyDto>> rmap = bServ.replyInsert(reply);
		return rmap;
	}
	
	@GetMapping("delete")
	public String delete(Integer pnum,Integer rnum,
			RedirectAttributes rttr) {
		log.info("pnum : " + pnum + ", rnum : " + rnum);
		
		String view = bServ.delete(pnum,rnum,rttr);
		
		
		return view;
	}
	
	@GetMapping("replysingo")
	public String replysingo(Integer pnum,Integer rnum,
			RedirectAttributes rttr) {
		log.info("pnum : " + pnum + ", rnum : " + rnum);
		
		String view = bServ.replysingo(pnum, rnum, rttr);
		
		return view;
		
	}
	
	@GetMapping("condel")
	public String condel(int pnum,
			RedirectAttributes rttr) {
		log.info("pnum : " + pnum);
		
		String view = bServ.condel(pnum, rttr);
		
		
		return view;
	}
	
	@GetMapping("likeup")
	public String likeup(Integer pnum, String mid,
							RedirectAttributes rttr) {
		
		log.info("pnum : " + pnum + ", mid : " + mid);
		
		String view = bServ.like(pnum, mid, rttr);
		
		return view;
	}
	
	@GetMapping("singo")
	public String singo(Integer pnum,
			RedirectAttributes rttr) {
		log.info("singo pnum : " + pnum);
		
		String view = bServ.singo(pnum, rttr);
		
		return view;
	}
	
	//건의사항
	@GetMapping("bSugList")
	public ModelAndView bSugList(Integer pageNum) {
		log.info("bSugList()");
		
		mv = bServ.getBoardList_5(pageNum);
		
		return mv;
	}
	
	@GetMapping("bWriteSugFrm")
	public String bWriteSugFrm() {
		log.info("bWriteSugFrm()");
		
		return "bWriteSugFrm";
	}
	
	@GetMapping("sugList")
	public ModelAndView sugList(Integer snum) {
		log.info("sugList : " + snum);
		
		mv = bServ.getsList(snum);
		
		return mv;
	}
	
	@PostMapping("sugData")
	public String sugData (MultipartHttpServletRequest multi,
	RedirectAttributes rttr) {
		log.info("sugData()");
		
		String view = bServ.SugData(multi, rttr);
		
		return view;
		
	}
	
	@GetMapping("sugdel")
	public String sugdel(Integer snum, RedirectAttributes rttr) {
		log.info("snum : " + snum);
		
		String view = bServ.Sugdel(snum, rttr);
		
		return view;
	}
	
	
	
	
	
}