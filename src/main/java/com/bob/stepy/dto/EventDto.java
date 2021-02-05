package com.bob.stepy.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class EventDto {
	private int e_num;
	private String e_title;
	private String e_contents;
	private Timestamp e_date;
}
