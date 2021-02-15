package com.bob.stepy.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.bob.stepy.dto.MemberDto;

import lombok.extern.java.Log;

@Log
public class SessionInterceptor extends HandlerInterceptorAdapter {
	
	@Autowired
	HttpSession session;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		log.info("preHandle() interceptor" );
		
		boolean bool;
		
		if(session.getAttribute("member") == null) {
			
			if(session.getAttribute("ceo") != null) {	
				return true;
			}else {
				response.sendRedirect("./");
				bool = false;
			}
			response.sendRedirect("./");
			bool = false;
		}else {

			bool = true;
		}

		return bool;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		
		if(request.getProtocol().equals("HTTP/1.1")) {
			response.setHeader("Cache-control", "no-cache, no-store, must-revalidate");
		}else {
			response.setHeader("Pragma","no-cache");
		}
		response.setDateHeader("Expires", 0);
	}

	
}




