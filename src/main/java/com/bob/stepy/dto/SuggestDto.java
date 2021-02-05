package com.bob.stepy.dto;

import java.sql.Timestamp;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class SuggestDto {
	private int sug_num;
	private String sug_title;
	private String sug_contents;
	private String sug_mid;
	private int sug_view;
	@JsonFormat(pattern = "yyyy-MM-dd")
	private Timestamp sug_date;
}


