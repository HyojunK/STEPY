package com.bob.stepy.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class MessageDto {

	private int ms_num;
	private String ms_mid;
	private String ms_smid;
	private String ms_contents;
	private Timestamp ms_date;
	private int ms_bfread;
	private int ms_afread;
	private String m_nickname;
	
}
