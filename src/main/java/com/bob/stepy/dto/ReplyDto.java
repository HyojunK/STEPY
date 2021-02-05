package com.bob.stepy.dto;

import java.sql.Timestamp;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class ReplyDto {
	private int r_num;
	private int r_pnum;
	private String r_contents;
	@JsonFormat(pattern="yyyy-MM-dd hh:mm")
	private Timestamp r_date;
	private String r_id;
	private String r_secret;
	private int r_report;
}
