package com.bob.stepy.dto;

import lombok.Data;

@Data
public class ChecklistViewDto {
	private long cl_plannum;
	private long cl_category;
	private String cl_categoryname;
}
