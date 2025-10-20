package com.example.test1.controller;

import java.io.File;
import java.util.Calendar;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.test1.dao.MemberService;
import com.google.gson.Gson;

@Controller
public class MemberController {

	@Autowired
	MemberService memberService;
	
	@Value("${client_id}")
	private String client_id;

    @Value("${redirect_uri}")
    private String redirect_uri;
	
	@RequestMapping("/member/login.do") 
    public String login(Model model) throws Exception{ 
		String location = "https://kauth.kakao.com/oauth/authorize?response_type=code&client_id="+client_id+"&redirect_uri="+redirect_uri;
        model.addAttribute("location", location);
		
        return "/member/member-login";
    }
	
	@RequestMapping("/member/join.do") 
    public String join(Model model) throws Exception{ 
		
        return "/member/member-join";
    }
	
	@RequestMapping("/member/pwd.do") 
    public String pwd(Model model) throws Exception{ 
		
        return "/member/pwd";
    }
	
	@RequestMapping("/mgr/member/list.do") 
    public String mgr(Model model) throws Exception{ 
        return "/mgr/member-list";
        
    }
	
	@RequestMapping("/mgr/member/view.do") 
	public String view(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		System.out.println(map.get("userId"));
		request.setAttribute("userId", map.get("userId"));
        return "/mgr/member-view";
    }
	
	@RequestMapping("/addr.do") 
    public String addr(Model model) throws Exception{ 
		
        return "/jusoPopup";
    }
	
	@RequestMapping(value = "/member/login.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String login(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = memberService.login(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/member/check.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String check(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = memberService.check(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/mgr/member/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String memberList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = memberService.getMemberList(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/mgr/remove-cnt.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeCnt(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = memberService.removeCnt(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/member/logout.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String logout(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = memberService.logout(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/member/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String add(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = memberService.memberInsert(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/member/auth.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String auth(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = memberService.authMember(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/member/pwd.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String pwd(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = memberService.updatePwd(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping("/userFileUpload.dox")
	public String result(@RequestParam("file1") MultipartFile multi, @RequestParam("userId") String userId, HttpServletRequest request,HttpServletResponse response, Model model)
	{
		String url = null;
		String path="c:\\img";
		try {

			//String uploadpath = request.getServletContext().getRealPath(path);
			String uploadpath = path;
			String originFilename = multi.getOriginalFilename();
			String extName = originFilename.substring(originFilename.lastIndexOf("."),originFilename.length());
			long size = multi.getSize();
			String saveFileName = genSaveFileName(extName);
			
//			System.out.println("uploadpath : " + uploadpath);
			System.out.println("originFilename : " + originFilename);
			System.out.println("extensionName : " + extName);
			System.out.println("size : " + size);
			System.out.println("saveFileName : " + saveFileName);
			String path2 = System.getProperty("user.dir");
			System.out.println("Working Directory = " + path2 + "\\src\\webapp\\img");
			if(!multi.isEmpty())
			{
				File file = new File(path2 + "\\src\\main\\webapp\\img", saveFileName);
				multi.transferTo(file);
				
				HashMap<String, Object> map = new HashMap<String, Object>();
				map.put("fileName", saveFileName);
				map.put("path", "/img/" + saveFileName);
				map.put("userId", userId);
				map.put("orgName", originFilename);
				map.put("size", size);
				map.put("ext", extName);
				
				// insert 쿼리 실행
			    memberService.addMemberImg(map);
				
				model.addAttribute("filename", multi.getOriginalFilename());
				model.addAttribute("uploadPath", file.getAbsolutePath());
				
				return "redirect:list.do";
			}
		}catch(Exception e) {
			System.out.println(e);
		}
		return "redirect:list.do";
	}
	    
	// 현재 시간을 기준으로 파일 이름 생성
	private String genSaveFileName(String extName) {
		String fileName = "";
		
		Calendar calendar = Calendar.getInstance();
		fileName += calendar.get(Calendar.YEAR);
		fileName += calendar.get(Calendar.MONTH);
		fileName += calendar.get(Calendar.DATE);
		fileName += calendar.get(Calendar.HOUR);
		fileName += calendar.get(Calendar.MINUTE);
		fileName += calendar.get(Calendar.SECOND);
		fileName += calendar.get(Calendar.MILLISECOND);
		fileName += extName;
		
		return fileName;
	}
	
}