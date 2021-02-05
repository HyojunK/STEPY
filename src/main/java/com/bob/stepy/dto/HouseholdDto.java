package com.bob.stepy.dto;

import lombok.Data;
@Data
public class HouseholdDto {
	private long h_plannum;
	private long h_day;
	private long h_cnt;
	private String h_mid;
	private long h_cost;
	private String h_category;
	private String h_contents;
	private String h_sname;
	private long h_curday;
	private long h_changecnt;
}
