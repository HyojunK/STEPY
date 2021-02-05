package com.bob.stepy.dto;

import java.sql.Timestamp;

import lombok.Data;
@Data
public class PostDto {
	private int p_num;
	private String p_title;
	private String p_contents;
	private String p_category;
	private Timestamp p_date;
	private int p_view;
	private int p_like;
	private String p_mid;
	private int p_report;
}
