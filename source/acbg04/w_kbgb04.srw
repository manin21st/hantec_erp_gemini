$PBExportHeader$w_kbgb04.srw
$PBExportComments$년예산 일괄생성
forward
global type w_kbgb04 from w_inherite
end type
type dw_list from datawindow within w_kbgb04
end type
end forward

global type w_kbgb04 from w_inherite
string title = "년예산 일괄생성"
dw_list dw_list
end type
global w_kbgb04 w_kbgb04

on w_kbgb04.create
int iCurrent
call super::create
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
end on

on w_kbgb04.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
end on

event open;call super::open;long ll_yyyy


dw_list.SetTransObject(sqlca)

dw_list.reset()

dw_list.insertrow(0)

ll_yyyy = long(string(today(), 'YYYY')) + 1
dw_list.SetItem(1, 'pre_yyyy', string(today(), 'YYYY'))  // 참조 예산년도
dw_list.SetItem(1, 'post_yyyy', string(ll_yyyy, '0000'))  // 생성 예산년도

dw_list.SetItem(1, 'ctr_rate', 100)

dw_list.SetColumn('pre_yyyy')
dw_list.setfocus()


end event

type dw_insert from w_inherite`dw_insert within w_kbgb04
integer x = 59
integer y = 2584
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kbgb04
boolean visible = false
integer x = 3378
integer y = 2160
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kbgb04
boolean visible = false
integer x = 3205
integer y = 2160
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kbgb04
boolean visible = false
integer x = 2510
integer y = 2160
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kbgb04
boolean visible = false
integer x = 3031
integer y = 2160
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kbgb04
integer taborder = 30
end type

type p_can from w_inherite`p_can within w_kbgb04
boolean visible = false
integer x = 3899
integer y = 2160
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kbgb04
boolean visible = false
integer x = 2683
integer y = 2160
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kbgb04
boolean visible = false
integer x = 2857
integer y = 2160
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_kbgb04
boolean visible = false
integer x = 3726
integer y = 2160
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kbgb04
integer x = 4270
integer taborder = 20
end type

event p_mod::clicked;call super::clicked;/* 작업내용 :                                                       */ 
/*           참조 예산년도의 자료선택을 바탕으로 생성 예산년도의    */ 
/*           기본금액 및 최초 배정금액을 생성하는 프로그램          */  
/*           1) 자료선택 : 기본예산금액(1), 실행예산금액(2),        */ 
/*                         집행예산금액(3)                          */ 
/* 공식 :                                                           */ 
/*       1) 기본예산금액 = 기본예산금액                             */ 
/*       2) 실행 예산금액 = 기본예산금액 + 추가 + 전용 +            */ 
/*                          조기집행(당겨쓰기)                      */ 
/*       3) 집행예산금액 = 집행예산금액                             */ 

string ls_saupj, ls_pre_yyyy, ls_post_yyyy, ls_jgbn, ls_bgbn, ls_dept_cd, &
       snull, get_code, get_name, get_gbn
decimal ll_ctr_rate
integer li_return 

SetNull(snull)

if dw_list.AcceptText() = -1 then return

ls_saupj = gs_saupj         /* 사업장         */

ls_pre_yyyy = dw_list.GetItemString(1, 'pre_yyyy')   /* 참조 예산년도  */
ls_post_yyyy = dw_list.GetItemString(1, 'post_yyyy')  /* 생성 예산년도  */
ls_jgbn = dw_list.GetItemString(1, 'jgbn')          /* 자료선택       */
ls_bgbn = dw_list.GetItemString(1, 'bgbn')          /* 예산구분       */
ls_dept_cd = dw_list.GetItemString(1, 'dept_cd')    /* 예산 부서      */
ll_ctr_rate = dw_list.GetItemNumber(1, 'ctr_rate')  /* 조정율         */

if isnull(ls_pre_yyyy) or trim(ls_pre_yyyy) = '' then 
   F_MessageChk(1, "[참조 예산년도]")
	dw_list.setcolumn('pre_yyyy')
	dw_list.setfocus()
	return
end if

if isnull(ls_post_yyyy) or trim(ls_post_yyyy) = '' then 
   F_MessageChk(1, "[참조 예산년도]")
	dw_list.setcolumn('post_yyyy')
	dw_list.setfocus()
	return
end if

if ls_pre_yyyy > ls_post_yyyy then 
	MessageBox("확 인", "참조 예산년도가 생성 예산년도보다 ~r~r 클 수 없습니다.!!")	
	dw_list.setcolumn('post_yyyy')
	dw_list.setfocus()
	return
end if


if isnull(ls_bgbn) or trim(ls_bgbn) = '' then 
	ls_bgbn = ''		
else
	SELECT "REFFPF"."RFGUB"
	INTO :get_gbn
	FROM "REFFPF" 
	WHERE "REFFPF"."RFCOD" = 'AB'   AND   
		   "REFFPF"."RFGUB" = :ls_bgbn AND   
		   "REFFPF"."RFGUB" <> '00';  
	if sqlca.sqlcode <> 0 or isnull(get_gbn) then 
		ls_bgbn = ''		
		dw_list.SetItem(1, 'bgbn', snull)
   end if
end if


if isnull(ls_dept_cd) or trim(ls_dept_cd) = '' then 
ls_dept_cd = ''
else

SELECT "KFE03OM0"."DEPTCODE",   
		  "KFE03OM0"."DEPTNAME"  
	 INTO :get_code,    
			:get_name  
	 FROM "KFE03OM0"  
	WHERE "KFE03OM0"."DEPTCODE" = :ls_dept_cd   ;

if sqlca.sqlcode <> 0 then 	
	ls_dept_cd = ''
	dw_list.SetItem(1, 'dept_cd', snull)
end if 

end if

if MessageBox("처  리", "자료를 생성하시겠습니까", QUESTION!, YesNo!) = 2 then return 

setpointer(hourglass!)

//서버 funtion u_create_transation에 선언되어 있슴.
// return : 1(성공), -1(funtion 오류), 2(범위를 벗어남)

li_return = sqlca.acfnbg01(ls_saupj, ls_pre_yyyy, ls_post_yyyy, &
                           ls_jgbn, ls_bgbn, ls_dept_cd, ll_ctr_rate)
									
if li_return = 1 THEN   // 성공
   setpointer(Arrow!)	
	sle_msg.text = "자료 생성에 성공하였습니다.!!"
elseif li_return = -1 THEN   // 실패 
   MessageBox("오 류", "서버에서 acfnbg01 실행중 에러 발생" + "~n" + "~n" + &
	                    "전산실로 문의하십시오!!")
	sle_msg.text = "자료 생성에 실패하였습니다.!!"							  
	setpointer(Arrow!)
	return
elseif li_return = 2 then  // 선택 범위를 벗어남...(작업이 이루어지지 않음)
   F_MessageChk(16, "[년예산 일괄 생성]")										
	setpointer(Arrow!)
	sle_msg.text = "선택한 범위에 생성할 자료가 존재하지 않습니다.!!"							  	
	return 
else
   MessageBox("오 류", "서버에서 acfnbg01 실행중 에러 발생" + "~n" + "~n" + &
	                    "전산실로 문의하십시오!!")
	sle_msg.text = "자료 생성에 실패하였습니다.!!"							  
	setpointer(Arrow!)
	return
end if

end event

type cb_exit from w_inherite`cb_exit within w_kbgb04
boolean visible = false
integer x = 3200
integer y = 1896
end type

type cb_mod from w_inherite`cb_mod within w_kbgb04
boolean visible = false
integer x = 2834
integer y = 1896
string text = "처리(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kbgb04
boolean visible = false
integer x = 951
integer y = 2620
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kbgb04
boolean visible = false
integer x = 1755
integer y = 2620
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_kbgb04
boolean visible = false
integer x = 590
integer y = 2620
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_kbgb04
integer x = 2752
integer y = 2620
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_kbgb04
boolean visible = false
integer y = 2088
end type

type cb_can from w_inherite`cb_can within w_kbgb04
boolean visible = false
integer x = 1390
integer y = 2620
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_kbgb04
integer x = 2702
integer y = 2620
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_kbgb04
boolean visible = false
integer y = 2088
end type

type sle_msg from w_inherite`sle_msg within w_kbgb04
boolean visible = false
integer y = 2088
end type

type gb_10 from w_inherite`gb_10 within w_kbgb04
boolean visible = false
integer y = 2036
end type

type gb_button1 from w_inherite`gb_button1 within w_kbgb04
boolean visible = false
integer x = 558
integer y = 2564
integer width = 773
integer height = 384
boolean enabled = false
end type

type gb_button2 from w_inherite`gb_button2 within w_kbgb04
boolean visible = false
integer x = 2798
integer y = 1840
integer width = 773
end type

type dw_list from datawindow within w_kbgb04
event ue_enterkey pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 1024
integer y = 448
integer width = 2510
integer height = 1240
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kbgb04_2"
boolean border = false
boolean livescroll = true
end type

event ue_enterkey;send(handle(this), 256, 9, 0)

return 1
end event

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string ls_dept_cd, get_code, get_name, get_gbn, snull, &
       ls_pre_yyyy, ls_post_yyyy, ls_bgbn

SetNull(snull)

if this.GetColumnName() = 'pre_yyyy' then 
	ls_pre_yyyy = this.GetText()
	if isnull(ls_pre_yyyy) or trim(ls_pre_yyyy) = "" then 
      F_MessageChk(1, "[참조 예산년도]")
		return 1
	end if
end if

if this.GetColumnName() = 'post_yyyy' then 
	ls_post_yyyy = this.GetText()
	ls_pre_yyyy = this.GetItemString(1, 'pre_yyyy')
	if isnull(ls_post_yyyy) or trim(ls_post_yyyy) = "" then 
      F_MessageChk(1, "[생성 예산년도]")
		return 1
	end if
	if ls_pre_yyyy > ls_post_yyyy then 
		MessageBox("확 인", "참조 예산년도가 생성 예산년도보다 ~r~r 클 수 없습니다.!!")
		return 1
	end if
end if

if this.GetcolumnName() = 'bgbn' then 
	ls_bgbn = this.GetText()
	if isnull(ls_bgbn) or trim(ls_bgbn) = '' then 
		return
	end if
    SELECT "REFFPF"."RFGUB"
    INTO :get_gbn
    FROM "REFFPF" 
	 WHERE "REFFPF"."RFCOD" = 'AB'   AND   
          "REFFPF"."RFGUB" = :ls_bgbn AND   
			 "REFFPF"."RFGUB" <> '00';  
	if sqlca.sqlcode = 0 and isnull(get_gbn) = false then 
	   return 
	else 
		this.SetItem(1, 'bgbn', snull)
		return 1
	end if
end if 

if this.GetColumnName() = 'dept_cd' then
	ls_dept_cd = this.GetText()
	if isnull(ls_dept_cd) or trim(ls_dept_cd) = "" then return

	SELECT "KFE03OM0"."DEPTNAME"
		 INTO :get_name  
		 FROM "KFE03OM0"  
		WHERE "KFE03OM0"."DEPTCODE" = :ls_dept_cd;
	if sqlca.sqlcode = 0 then 	
		this.SetItem(row, 'dept_cd', ls_dept_cd)
	end if
end if
end event

event itemerror;return 1
end event

