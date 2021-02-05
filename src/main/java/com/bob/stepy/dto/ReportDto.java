package com.bob.stepy.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class ReportDto {
	private int rp_num;
	private String rp_title;
	private String rp_category;
	private String rp_story;
	private Timestamp rp_date;
	private String rp_mid;
	private String rp_condition;
	private String rp_cnum;
}
