package com.example.test1.controller;

import java.util.Random;

public class Test {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		// 랜덤한 숫자 6자리(0~9)
		Random ran = new Random();
		String ranStr = "";
	
		for(int i=0; i<6; i++) {
			ran.nextInt(10);
			ranStr += ran.nextInt(10);
		}

		System.out.println(ranStr);
	}

}