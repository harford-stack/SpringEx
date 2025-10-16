package com.example.test1.dao;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.test1.mapper.MemberMapper;
import com.example.test1.model.Member;

@Service
public class MemberService {
	
	@Autowired
	MemberMapper memberMapper;
	
	@Autowired
	HttpSession session;
	
	@Autowired
	PasswordEncoder passwordEncoder;
	
	public HashMap<String, Object> login(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		Member member = memberMapper.memberLogin(map);
//		String message = member != null ? "로그인 성공!" : "로그인 실패!";
//		String result = member != null ? "success" : "fail";
		
		
		String message = ""; // 로그인 성공 실패 여부 메세지
		String result = ""; // 로그인 성공 실패 여부
		
		// 해시 적용 후 버전
		
		if(member != null) {
			// 아이디가 존재, 비밀번호 비교하기 전
			// 사용자가 보낸 비밀번호 map에서 꺼낸 후 해시화한 값과
			// member 객체 안에 있는 password와 비교
			Boolean loginFlg = passwordEncoder.matches((String) map.get("pwd"), member.getPassword());
			System.out.println(loginFlg);
			if(loginFlg) {
				// 비밀번호를 정상적으로 입력했을 경우
				if(member.getCnt() >= 5) {
					// 비밀번호를 정상입력했지만, 이전에 5회 이상 틀린 경우
					message = "비밀번호를 5회 이상 잘못 입력하셨습니다.";
					result = "fail";
				} else {
					// 로그인 성공
					// 로그인 성공 시 cnt 값 0으로 초기화
					memberMapper.cntInit(map);
					message = "로그인 성공!";
					result = "success";
					session.setAttribute("sessionId", member.getUserId());
					session.setAttribute("sessionName", member.getName());
					session.setAttribute("sessionStatus", member.getStatus());
					if(member.getStatus().equals("A")) {
						resultMap.put("url", "/mgr/member/list.do");
					} else {
						resultMap.put("url", "/main.do");
					}
				}
			} else {
				// 아이디는 맞지만, 비밀번호가 다른 경우
				memberMapper.cntIncrease(map);
				message = "패스워드를 확인해주세요.";
				result = "fail";
			}
			
		} else {
			// 아이디가 없음
			message = "아이디가 존재하지 않습니다.";
			result = "fail";
		}
		
		
		// ------------------------------------------------
		
		// 해시 적용 전 버전
		
//		if(member != null && member.getCnt() >= 5) {
//			message = "비밀번호를 5회 이상 잘못 입력하셨습니다.";
//			result = "fail";
//		} else if(member != null) {
//			// 로그인 성공 시 cnt 값 0으로 초기화
//			memberMapper.cntInit(map);
//			message = "로그인 성공!";
//			result = "success";
//			session.setAttribute("sessionId", member.getUserId());
//			session.setAttribute("sessionName", member.getName());
//			session.setAttribute("sessionStatus", member.getStatus());
//			if(member.getStatus().equals("A")) {
//				resultMap.put("url", "/mgr/member/list.do");
//			} else {
//				resultMap.put("url", "/main.do");
//			}
//		} else {
//			Member idCheck = memberMapper.memberCheck(map);
//			if(idCheck != null) {
//				// 로그인 실패 시 cnt 1 증가
//				if(idCheck.getCnt() >= 5) {
//					message = "비밀번호를 5회 이상 잘못 입력하셨습니다.";
//				} else {
//					memberMapper.cntIncrease(map);
//					message = "패스워드를 확인해주세요.";
//				}
//			} else {
//				message = "아이디가 존재하지 않습니다.";
//			}
//		}
		
		resultMap.put("msg", message);
		resultMap.put("result", result);
		
		return resultMap;
	}
	
	public HashMap<String, Object> check(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		Member member = memberMapper.memberCheck(map);
		
		String result = member != null ? "true" : "false";
		resultMap.put("result", result);
		
		return resultMap;
	}

	public HashMap<String, Object> logout(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		// 세션정보 삭제하는 방법은 
		// 1개씩 키값을 이용해 삭제하거나, 전체를 한번에 삭제
		
		String message = session.getAttribute("sessionName") + "님 로그아웃 되었습니다.";
		resultMap.put("msg", message);
		
//		session.removeAttribute("sessionId"); // 1개씩 삭제
		
		session.invalidate(); // 세션정보 전체 삭제
		
		return resultMap;
	}
	
	public HashMap<String, Object> memberInsert(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		String hashPwd = passwordEncoder.encode((String) map.get("pwd"));
		map.put("hashPwd", hashPwd);
		
		int cnt = memberMapper.memberAdd(map);
		
		if(cnt < 1) {
			resultMap.put("result", "fail");
		} else {
			resultMap.put("result", "success");
		}
		
		return resultMap;
	}

	public void addMemberImg(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		int cnt = memberMapper.insertMemberImg(map);
	}
	
	public HashMap<String, Object> getMemberList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Member> list = memberMapper.selectMemberList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}

	public HashMap<String, Object> removeCnt(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			memberMapper.cntInit(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> authMember(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			// 둘 중 하나 선택
			// 1. 리턴 member
			Member member = memberMapper.authMember1(map);
			if(member != null) {
				resultMap.put("result", "success");
			} else {
				resultMap.put("result", "fail");
			}
			
			// 2. 리턴 int
//			int cnt = memberMapper.authMember2(map);
//			if(cnt == 1) {
//				resultMap.put("result", "success");
//			} else {
//				resultMap.put("result", "fail");
//			}
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> updatePwd(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Member member = memberMapper.memberLogin(map);
			Boolean pwdFlg = passwordEncoder.matches((String) map.get("pwd"), member.getPassword());
			if(pwdFlg) {
				resultMap.put("result", "fail");
				resultMap.put("msg", "비밀번호가 이전과 동일합니다.");
			} else {
				String hashPwd = passwordEncoder.encode((String) map.get("pwd"));
				map.put("hashPwd", hashPwd);
				memberMapper.updatePwd(map);
				resultMap.put("result", "success");
				resultMap.put("msg", "수정되었습니다.");
			}
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("msg", "오류가 발생했습니다..");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	

	
}