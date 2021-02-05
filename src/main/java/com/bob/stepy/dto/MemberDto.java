package com.bob.stepy.dto;

import lombok.Data;

@Data
public class MemberDto {
	private String m_id;
	private String m_pwd;
	private String m_email;
	private String m_name;
	private String m_nickname;
	private String m_birth ="";
	private String m_gender = "";
	private String m_phone="";
	private String m_addr = "";
	
	private String address_without_specific;
	private String address_with_specific;
}
