package kr.or.pms.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.IOUtils;
import org.apache.el.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.or.pms.dto.IssueVO;
import kr.or.pms.dto.MenuVO;
import kr.or.pms.dto.PrjUserVO;
import kr.or.pms.dto.ProjectVO;
import kr.or.pms.dto.RecoverPwdVO;
import kr.or.pms.dto.ScheduleVO;
import kr.or.pms.dto.UserVO;
import kr.or.pms.dto.WorkVO;
import kr.or.pms.mail.MailMessageCommand;
import kr.or.pms.mail.MimeAttachNotifier;
import kr.or.pms.service.CalendarService;
import kr.or.pms.service.HtmlTempService;
import kr.or.pms.service.IssueService;
import kr.or.pms.service.LogService;
import kr.or.pms.service.MenuService;
import kr.or.pms.service.ProjectService;
import kr.or.pms.service.UserService;
import kr.or.pms.service.WorkService;
import kr.or.pms.util.MakeFileName;
import kr.or.pms.util.UserSha256;

@Controller
public class CommonController {
	
	@Autowired
	private MimeAttachNotifier notifier;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private HtmlTempService htmlTempService;
	
	@Autowired
	private MenuService menuService;
	
	@Autowired
	private ProjectService prjService;
	
	@Autowired
	private WorkService workService;
	
	@Autowired
	private LogService logService;
	
	@Resource(name="calendarService")
	private CalendarService calendarService;
	
	@Resource(name="issueService")
	private IssueService issueService;
	
	@RequestMapping("/index")
	public String index(Model model) throws SQLException {
		String url = "index";
		return url;
	}
	@RequestMapping("/dashboard")
	public String dashboard(HttpServletRequest request, Model model) throws Exception {
		String url = "common/dashboard";
		
		HttpSession session = request.getSession();
		UserVO loginUser = (UserVO) session.getAttribute("loginUser");
		
		// ???????????? ???????????? ??????
		List<ProjectVO> joinPrjList = prjService.getJoinProjectList(loginUser.getUserId());
		// ??? ???????????? ??????
		List<ProjectVO> teamPrjList = prjService.getTeamProjectList(loginUser.getUserId());
		// ???????????? ???????????? ?????? ?????? ?????? - ???????????? ???????????? ??????
		List<WorkVO> workList = workService.getWorkListHomeById(loginUser.getUserId());
		// ???????????? ?????????????????? ????????? ?????? ?????? - ???????????? ???????????? ??????
		List<IssueVO> issueList = issueService.getDashBoardIssue(loginUser.getUserId());
		
		model.addAttribute("joinPrjList", joinPrjList);
		model.addAttribute("teamPrjList", teamPrjList);
		model.addAttribute("workList", workList);
		model.addAttribute("issueList", issueList);
		
		return url;
	}
	@RequestMapping("/admin/dashboard")
	public String adminDashboard() throws SQLException {
		String url = "admin/dashboard";
		return url;
	}
	
	@RequestMapping("/getMenuList")
	@ResponseBody
	public ResponseEntity<List<MenuVO>> getMenuList(@RequestParam(defaultValue="")String mType, HttpSession session) throws SQLException {
		
		ResponseEntity<List<MenuVO>> entity = null;
		UserVO user = (UserVO) session.getAttribute("loginUser");
		String authGrpCode = user.getAuthGrpCode();
		
		List<MenuVO> menuList = menuService.getMenuList(mType, authGrpCode);
		
		entity = new ResponseEntity<List<MenuVO>>(menuList, HttpStatus.OK);
		
		return entity;
	}
	
	@RequestMapping("/myProject")
	@ResponseBody
	public String myProject(HttpServletRequest request, RedirectAttributes rttr) throws Exception {
		
		UserVO user = (UserVO)request.getSession().getAttribute("loginUser");
		String userId = user.getUserId();
		
		Map<String, Object> dataMap = calendarService.selectCalendar(userId);
		
		@SuppressWarnings("unchecked")
		List<PrjUserVO> prjUserList = (List<PrjUserVO>) dataMap.get("prjUserList");
		List<PrjUserVO> prjUserList2 = new ArrayList<PrjUserVO>();
		for(PrjUserVO vo : prjUserList) {
			vo.setUrl("/project/home.do?from=list&prjNo="+vo.getPrjNo());
			ProjectVO prjVO = prjService.getProject(vo.getPrjNo());
			if(prjVO.getSttCode().equals("p")) {
				prjUserList2.add(vo);
			}
		}
		
		dataMap.put("prjUserList", prjUserList2);
		
		String json = new ObjectMapper().writeValueAsString(prjUserList2);
		return json;
		
	}
	
	@RequestMapping("/security/accessDenied")
	public void accessDenied() {}

	@RequestMapping("/security/systemLock")
	public void systemLock() {}
	
	@RequestMapping("/common/loginTimeOut")
	public String loginTimeOut(HttpServletRequest request, Model model)throws Exception {
		
		String url="security/sessionOut";
		
		/* ???????????? ?????? ????????? ?????? ??????1(?????? ?????? ??????) */
		HttpSession session = request.getSession();
		UserVO loginUser = (UserVO) session.getAttribute("loginUser");
			
		if (loginUser != null) {
		String loginUserId = loginUser.getUserId();
		
		logService.modifyLogoutLog(loginUserId);
		}
		
		
		model.addAttribute("message","????????? ?????????????????????.\\n?????? ????????? ?????????!");
		return url;
	}
	@RequestMapping(value = "/common/loginForm", method = RequestMethod.GET)
	public String loginForm(@RequestParam(defaultValue="")String error, HttpServletResponse response) {
		String url = "common/loginForm";		
		
		if(error.equals("1")) {
			response.setStatus(302);
		}
		return url;
	}
	@RequestMapping(value = "/common/forgotId", method = RequestMethod.GET)
	public String forgotId() {
		String url = "common/forgotId";	
		return url;
	}
	@RequestMapping(value = "/common/findId", method = RequestMethod.POST)
	public ModelAndView findId(@RequestParam(defaultValue="")String email, ModelAndView mnv) throws Exception {
		String url = "common/findId";	
		
		String userId = userService.getUserIdByEmail(email);
		String message = "???????????? ?????? ??????????????????.";
		if(userId!=null) {
			message = "???????????? ??????????????? " + userId + " ?????????.";
		}
		
		mnv.addObject("message", message);
		mnv.addObject("userId", userId);
		
		//????????????.
		mnv.setViewName(url);
		
		return mnv;
	}
	@RequestMapping(value = "/common/forgotPwd", method = RequestMethod.GET)
	public String forgotPwd() {
		String url = "common/forgotPwd";		
		return url;
	}
	@RequestMapping(value = "/common/findPwd", method = RequestMethod.POST)
	public ModelAndView findPwd(@RequestParam(defaultValue="")String email, @RequestParam(defaultValue="")String id, ModelAndView mnv) throws Exception {
		String url = "common/findPwd";	
		
		UserVO user = userService.getUser(id);
		String message = "";
		String isFail = "true";
		
		if(user!=null) {
			String userEmail = user.getEmail();
			
			if(userEmail.equals(email)) {
				
				//?????? ????????? ?????????	
				try {
					
					MailMessageCommand mailReq = new MailMessageCommand();
					String key = UUID.randomUUID().toString();
					
					RecoverPwdVO rpVO = new RecoverPwdVO();
					rpVO.setKey(key);
					rpVO.setUserId(id);
					userService.registRecoverKey(rpVO);
					
					//????????? ???????????? ???????????? ??????
					List<String> paramList = new ArrayList<String>();
					paramList.add(id);
					paramList.add("http://192.168.144.16/pms/common/recoverPwd.do?key="+ key);
					
					//TEMP ???????????? ??????????????? tempNm, ???????????? tempNm, ???????????? ????????? ???
					String htmlStr = htmlTempService.getHtmlStr("basic", "recoverPwd", paramList);
					
					mailReq.setReceiver(userEmail);
					mailReq.setTitle("PROSPEC'S ?????? ?????? ?????????");
					mailReq.setContent(htmlStr);
					notifier.sendMail(mailReq);
					
					message = "??????????????? ???????????? ??????????????????.";
					isFail = "false";

				}catch(Exception e) {
					e.printStackTrace();
					url="security/fail";
					message = "?????? ???????????? ??????????????????.";
				}
				
				
			} else {				
				message = "??????????????? ???????????? ????????????.";
			}
		} else {
			message = "???????????? ?????? ?????????????????????.";
		}
		
		mnv.addObject("message", message);
		mnv.addObject("userId", id);
		mnv.addObject("isFail", isFail);
		
		//????????????.
		mnv.setViewName(url);
		return mnv;
	}
	
	@RequestMapping(value = "/common/recoverPwd", method = RequestMethod.GET)
	public String recoverPwd() {
		String url = "common/recoverPwd";		
		return url;
	}
	@RequestMapping(value = "/common/recoverPwd", method = RequestMethod.POST)
	public ModelAndView recoverPw(RecoverPwdVO rpVO, ModelAndView mnv) {
		String url = "common/findPwd";
		String message = "";
		String isFail = "true";
		
		String encryPassword = UserSha256.encrypt(rpVO.getPwd());
		rpVO.setPwd(encryPassword);
		
		try {
			
			String userId = userService.recoverPwd(rpVO);
			
			isFail = "false";
			message = "???????????? ?????? ??????";
			
			mnv.addObject("userId", userId);
			
		} catch (Exception e) {
			e.printStackTrace();
			message = "???????????? ?????? ??????. ?????? ????????????????????????.";
		}
		
		
		mnv.addObject("message", message);
		mnv.addObject("isFail", isFail);
		
		//????????????.
		mnv.setViewName(url);
		return mnv;
	}
	
	
	@Resource(name="summernoteImgPath")
	private String imgPath;
	
	@RequestMapping(value="/uploadImg",produces = "text/plain;charset=utf-8")
	public ResponseEntity<String> uploadImg(MultipartFile file, HttpServletRequest request)throws IOException {
		ResponseEntity<String> result = null;
		
		int fileSize = 5 * 1024 * 1024; // 5MB ??????
		if (file.getSize() > fileSize) {
			return new ResponseEntity<String>("?????? ???????????????.", HttpStatus.BAD_REQUEST);
		}

		String savePath = imgPath.replace("/", File.separator);
		String fileName = MakeFileName.toUUIDFileName(file.getOriginalFilename(), "");
		File saveFile = new File(savePath, fileName);

		saveFile.mkdirs();

		file.transferTo(saveFile);
		result = new ResponseEntity<String>(request.getContextPath() + "/getImg.do?fileName=" + fileName,
				HttpStatus.OK);
		
		return result;
	}

	@RequestMapping("/getImg")
	public ResponseEntity<byte[]> getImg(String fileName, HttpServletRequest request) throws Exception {
		ResponseEntity<byte[]> entity = null;

		String savePath = imgPath.replace("/", File.separator);
		File sendFile = new File(savePath, fileName);

		InputStream in = null;

		try {

			in = new FileInputStream(sendFile);
			entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), HttpStatus.CREATED);

		} finally {
			if(in!=null)in.close();
		}

		return entity;
	}

	@RequestMapping("/deleteImg")
	public ResponseEntity<String> deleteImg(@RequestBody Map<String, String> data) throws Exception {
		ResponseEntity<String> result = null;

		String savePath = imgPath.replace("/", File.separator);
		File target = new File(savePath, data.get("fileName"));

		if (!target.exists()) {
			result = new ResponseEntity<String>(HttpStatus.BAD_REQUEST);
		} else {

			target.delete();
			result = new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		}

		return result;
	}
	
	
	@RequestMapping("/dashboard/date")
	@ResponseBody
	public String printDate(@RequestBody Map<String, String> dateJson, HttpServletRequest request, RedirectAttributes rttr) throws Exception {
		
		UserVO loginUser = (UserVO) request.getSession().getAttribute("loginUser");
		
		String date = dateJson.get("date");
		String dt = date.split("-")[0] + date.split("-")[1] + date.split("-")[2];
		
		ScheduleVO sche = new ScheduleVO();
		sche.setSelectDt(dt);
		sche.setRegister(loginUser.getUserId());
		
		List<ScheduleVO> scheduleList = calendarService.selectScheduleByDt(sche);
		for(ScheduleVO vo : scheduleList) {
			vo.setSelectDt(date);
			
			if(vo.getContent().contains("<p>")) {
				String content = vo.getContent().split("<p>")[1];
				String content1 = content.split("</p>")[0];
				vo.setContent(content1);
			} 
		}
		
		String json = new ObjectMapper().writeValueAsString(scheduleList);
		return json;
		
	}
	
	@RequestMapping("/dashboard/display")
	@ResponseBody
	public String displayDate(@RequestBody Map<String, String> dateJson, HttpServletRequest request, RedirectAttributes rttr) throws Exception {
		
		UserVO user = (UserVO) request.getSession().getAttribute("loginUser");
		String userId = user.getUserId();
		List<Map<String, String>> dataList = new ArrayList<Map<String,String>>();
		
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
		
		Map<String, Object> dataMap = calendarService.selectCalendar(userId);
		@SuppressWarnings("unchecked")
		List<PrjUserVO> prjUserList = (List<PrjUserVO>) dataMap.get("prjUserList");
		
		
		String date = dateJson.get("date");
		
		
		List<ScheduleVO> scheduleList = calendarService.selectCompany();
		scheduleList.addAll(calendarService.selectPersonal(userId));
		for(PrjUserVO vo : prjUserList) {
			scheduleList.addAll(calendarService.selectProject(vo.getPrjNo()));
		}
		Set<String> putDate = new HashSet<String>();
		
		for(int i=-30; i<=30; i++) {
			
			Calendar bgn = Calendar.getInstance();
			bgn.setTime(simpleDateFormat.parse(date));
			bgn.add(Calendar.DATE, i); 
			String bgnStr = simpleDateFormat.format(bgn.getTime());
			
			
			for(ScheduleVO vo : scheduleList) {
				boolean withinRange = isWithinRange(bgnStr,simpleDateFormat.format(vo.getBgnDt()),simpleDateFormat.format(vo.getEndDt()));
				
				if(withinRange==true) {
					Map<String, String> data = new HashMap<String, String>();
					
					int check = putDate.size();
					putDate.add(bgnStr);
					
					if(check != putDate.size()) {
						
						data.put("start",bgnStr);
						data.put("end",bgnStr);
						data.put("backgroundColor","#d3c0d3");
						data.put("borderColor","#d3c0d3");
						
						dataList.add(data);
					}
					
				}
			}
			
			
		}
		
		
		String json = new ObjectMapper().writeValueAsString(dataList);
		return json;
		
	}
	public static boolean isWithinRange(String date, String startDate, String endDate) throws ParseException {
		if(date.length() != 10 || startDate.length() != 10 || endDate.length() != 10){
			return false;
		}        
		
//		date = date.substring(0,4) + "-" + date.substring(4, 6) + "-" + date.substring(6, 8);
//		startDate = startDate.substring(0,4) + "-" + startDate.substring(4, 6) + "-" + startDate.substring(6, 8);
//		endDate = endDate.substring(0,4) + "-" + endDate.substring(4, 6) + "-" + endDate.substring(6, 8);
		
		LocalDate localdate = LocalDate.parse(date);
		LocalDate startLocalDate = LocalDate.parse(startDate);
		LocalDate endLocalDate = LocalDate.parse(endDate);
		endLocalDate = endLocalDate.plusDays(1); // endDate??? ???????????? ???????????? +1?????? ????????????.
		
		return ( ! localdate.isBefore( startLocalDate ) ) && ( localdate.isBefore( endLocalDate ) );
	}
}

