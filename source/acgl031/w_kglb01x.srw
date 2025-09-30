$PBExportHeader$w_kglb01x.srw
$PBExportComments$전표등록 : 기존전표 조회 선택
forward
global type w_kglb01x from window
end type
type cb_v from commandbutton within w_kglb01x
end type
type cb_q from commandbutton within w_kglb01x
end type
type p_end from uo_picture within w_kglb01x
end type
type p_inq from uo_picture within w_kglb01x
end type
type dw_rtv from datawindow within w_kglb01x
end type
type dw_2 from u_d_select_sort within w_kglb01x
end type
type dw_cond from datawindow within w_kglb01x
end type
type rr_1 from roundrectangle within w_kglb01x
end type
end forward

global type w_kglb01x from window
integer x = 73
integer y = 36
integer width = 3849
integer height = 2124
boolean titlebar = true
string title = "전표 조회"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
cb_v cb_v
cb_q cb_q
p_end p_end
p_inq p_inq
dw_rtv dw_rtv
dw_2 dw_2
dw_cond dw_cond
rr_1 rr_1
end type
global w_kglb01x w_kglb01x

type variables
Long  il_AryCnt
end variables

event open;String sDeptCode

f_window_center_Response(this)

dw_rtv.SetTransObject(SQLCA)

dw_cond.SetTransObject(sqlca)
dw_cond.InsertRow(0)

dw_2.SetTransObject(sqlca)

lstr_jpra.flag = False

il_AryCnt =Message.LongParm


IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
	dw_cond.Modify("dept_cd.protect = 1")	
	dw_cond.Modify("dept_cd2.protect = 1")
ELSE
	dw_cond.Modify("dept_cd.protect = 0")
	
	dw_cond.Modify("dept_cd2.protect = 0")
END IF

dw_cond.SetItem(dw_cond.GetRow(),"saupj",   lstr_jpra.saupjang)
dw_cond.SetItem(dw_cond.GetRow(),"dept_cd2",lstr_jpra.dept)

dw_cond.SetItem(dw_cond.GetRow(),"sdate",Left(lstr_jpra.baldate,4)+Mid(lstr_jpra.baldate,5,2)+"01")
dw_cond.SetItem(dw_cond.GetRow(),"edate",lstr_jpra.baldate)

if lstr_jpra.jun_gu = '1' then
	dw_cond.Modify("t_jungu.text = '입금전표'")
elseif  lstr_jpra.jun_gu = '2' then
	dw_cond.Modify("t_jungu.text = '출금전표'")
else
	dw_cond.Modify("t_jungu.text = '대체전표'")
end if

p_inq.TriggerEvent(Clicked!)

dw_cond.SetColumn("sdate")
dw_cond.SetFocus()

w_mdi_frame.sle_msg.text = '전표를 상세히 보고자 할 때 Double Click하십시오.!!'




end event

on w_kglb01x.create
this.cb_v=create cb_v
this.cb_q=create cb_q
this.p_end=create p_end
this.p_inq=create p_inq
this.dw_rtv=create dw_rtv
this.dw_2=create dw_2
this.dw_cond=create dw_cond
this.rr_1=create rr_1
this.Control[]={this.cb_v,&
this.cb_q,&
this.p_end,&
this.p_inq,&
this.dw_rtv,&
this.dw_2,&
this.dw_cond,&
this.rr_1}
end on

on w_kglb01x.destroy
destroy(this.cb_v)
destroy(this.cb_q)
destroy(this.p_end)
destroy(this.p_inq)
destroy(this.dw_rtv)
destroy(this.dw_2)
destroy(this.dw_cond)
destroy(this.rr_1)
end on

type cb_v from commandbutton within w_kglb01x
integer x = 4055
integer y = 508
integer width = 251
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "선택(&V)"
end type

event clicked;p_end.TriggerEvent(Clicked!)
end event

type cb_q from commandbutton within w_kglb01x
integer x = 4050
integer y = 412
integer width = 251
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&Q)"
end type

event clicked;p_inq.TriggerEvent(Clicked!)
end event

type p_end from uo_picture within w_kglb01x
integer x = 3621
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\choose.cur"
string picturename = "C:\erpman\image\선택_up.gif"
end type

event clicked;call super::clicked;
Integer iSelectedRow,iCurRow,iRowCount,k
String  sSaupj,sBalDate,sUpmuGbn,sCusGbn
Long    lBJunNo

iSelectedRow =	dw_2.GetSelectedRow(0)
If iSelectedRow = 0 then
	lstr_jpra.flag = False
   CloseWithReturn(w_kglb01x,0)
ELSE
	
	il_arycnt = 0
	
	sSaupj   = dw_2.GetItemString(iSelectedRow,"saupj")
	sBalDate = dw_2.GetItemString(iSelectedRow,"bal_date") 
	sUpmuGbn = dw_2.GetItemString(iSelectedRow,"upmu_gu") 
	lBJunNo  = dw_2.GetItemNumber(iSelectedRow,"bjun_no")
	
	dw_rtv.Reset()

	iRowCount = dw_rtv.Retrieve(sSaupj,sBalDate,sUpmuGbn,lBJunNo)
		
	/*입/출전표일 경우 현금계정은 포함 안함:2003.05.30*/
	if lstr_jpra.jun_gu <> '3' then				/*입.출전표*/
	
		dw_rtv.SetFilter("dcr_gu <> '" + lstr_jpra.jun_gu +"'")
		dw_rtv.Filter()
	end if
	
	iRowCount = dw_rtv.RowCount()
	
	FOR k = 1 TO iRowCount
		il_AryCnt = il_AryCnt + 1
			
		lstr_junpoy[il_AryCnt].acc1     = dw_rtv.GetItemString(k,"acc1_cd")
		lstr_junpoy[il_AryCnt].acc2     = dw_rtv.GetItemString(k,"acc2_cd")
		lstr_junpoy[il_AryCnt].saupno   = dw_rtv.GetItemString(k,"saup_no")
		
		/*거래처관리유무 체크*/
		SELECT "KFZ01OM0"."CUS_GU"  INTO :sCusGbn  
		   FROM "KFZ01OM0"  
		   WHERE ( "KFZ01OM0"."ACC1_CD" = :lstr_junpoy[il_AryCnt].acc1 ) AND  
        			( "KFZ01OM0"."ACC2_CD" = :lstr_junpoy[il_AryCnt].acc2  )   ;
		IF sCusGbn = 'Y' AND &
				(lstr_junpoy[il_AryCnt].saupno = "" OR IsNull(lstr_junpoy[il_AryCnt].saupno)) THEN
			F_MessageChk(16,'[거래처관리 Y,거래처 없슴 : '+String(iCurRow)+'번 자료]')
			Return 
		END IF 
			
		lstr_junpoy[il_AryCnt].saupjang = dw_rtv.GetItemString(k,"saupj")
		lstr_junpoy[il_AryCnt].baldate  = dw_rtv.GetItemString(k,"bal_date")
		lstr_junpoy[il_AryCnt].upmugu   = dw_rtv.GetItemString(k,"upmu_gu")
		lstr_junpoy[il_AryCnt].bjunno   = dw_rtv.GetItemNumber(k,"bjun_no")
		lstr_junpoy[il_AryCnt].sortno   = dw_rtv.GetItemNumber(k,"lin_no")
		lstr_junpoy[il_AryCnt].dept     = dw_rtv.GetItemString(k,"dept_cd")
		lstr_junpoy[il_AryCnt].chadae   = dw_rtv.GetItemString(k,"dcr_gu")
		lstr_junpoy[il_AryCnt].acc1_nm  = dw_rtv.GetItemString(k,"kfz01om0_acc1_nm")
		lstr_junpoy[il_AryCnt].accname  = dw_rtv.GetItemString(k,"kfz01om0_acc2_nm")
		lstr_junpoy[il_AryCnt].money    = dw_rtv.GetItemNumber(k,"amt")
		lstr_junpoy[il_AryCnt].desc     = dw_rtv.GetItemString(k,"descr")
		
		lstr_junpoy[il_AryCnt].cdept_cd = dw_rtv.GetItemString(k,"cdept_cd")
		lstr_junpoy[il_AryCnt].sdept_cd = dw_rtv.GetItemString(k,"sdept_cd")
		lstr_junpoy[il_AryCnt].jun_gu   = dw_rtv.GetItemString(k,"jun_gu")
		lstr_junpoy[il_AryCnt].sawon    = dw_rtv.GetItemString(k,"sawon")
		lstr_junpoy[il_AryCnt].vatamt   = dw_rtv.GetItemNumber(k,"vatamt")
		lstr_junpoy[il_AryCnt].in_cd    = dw_rtv.GetItemString(k,"in_cd")
		lstr_junpoy[il_AryCnt].in_nm    = dw_rtv.GetItemString(k,"in_nm")
		
		lstr_junpoy[il_AryCnt].kwan     = dw_rtv.GetItemString(k,"kwan_no")
		lstr_junpoy[il_AryCnt].status   = dw_rtv.GetItemString(k,"exp_gu")
		lstr_junpoy[il_AryCnt].k_amt    = dw_rtv.GetItemNumber(k,"k_amt")
		lstr_junpoy[il_AryCnt].k_uprice = dw_rtv.GetItemNumber(k,"k_uprice")
		lstr_junpoy[il_AryCnt].k_rate   = dw_rtv.GetItemNumber(k,"k_rate")
		lstr_junpoy[il_AryCnt].ymoney   = dw_rtv.GetItemNumber(k,"y_amt")
		lstr_junpoy[il_AryCnt].yrate    = dw_rtv.GetItemNumber(k,"y_rate")
		lstr_junpoy[il_AryCnt].pjt_no   = dw_rtv.GetItemString(k,"pjt_no")
		lstr_junpoy[il_AryCnt].itm_gu   = dw_rtv.GetItemString(k,"itm_gu")
		lstr_junpoy[il_AryCnt].y_curr   = dw_rtv.GetItemString(k,"y_curr")
		lstr_junpoy[il_AryCnt].k_symd   = dw_rtv.GetItemString(k,"k_symd")
		lstr_junpoy[il_AryCnt].k_eymd   = dw_rtv.GetItemString(k,"k_eymd")
		lstr_junpoy[il_AryCnt].yesan_amt= dw_rtv.GetItemNumber(k,"yesan_amt")
		lstr_junpoy[il_AryCnt].yesan_jan= dw_rtv.GetItemNumber(k,"yesan_jan")
		lstr_junpoy[il_AryCnt].send_bank= dw_rtv.GetItemString(k,"send_bank")
		lstr_junpoy[il_AryCnt].send_dep = dw_rtv.GetItemString(k,"send_dep")
		lstr_junpoy[il_AryCnt].send_nm  = dw_rtv.GetItemString(k,"send_nm")
		lstr_junpoy[il_AryCnt].cr_cd    = dw_rtv.GetItemString(k,"cr_cd")
		
		lstr_junpoy[il_AryCnt].flag_sanggae = dw_rtv.GetItemString(k,"cross_gu")
		lstr_junpoy[il_AryCnt].flag_jbill   = dw_rtv.GetItemString(k,"jbill_gu")
		lstr_junpoy[il_AryCnt].flag_buga    = dw_rtv.GetItemString(k,"vat_gu")
		lstr_junpoy[il_AryCnt].flag_jupdae  = dw_rtv.GetItemString(k,"jub_gu")
		lstr_junpoy[il_AryCnt].flag_rbill   = dw_rtv.GetItemString(k,"rbill_gu")
		lstr_junpoy[il_AryCnt].flag_chaip   = dw_rtv.GetItemString(k,"chaip_gu")
		lstr_junpoy[il_AryCnt].flag_secu    = dw_rtv.GetItemString(k,"secu_gu")
		lstr_junpoy[il_AryCnt].flag_aset    = dw_rtv.GetItemString(k,"aset_gu")
					
		lstr_junpoy[il_AryCnt].gyul_date    = dw_rtv.GetItemString(k,"gyul_date")
		lstr_junpoy[il_AryCnt].gyul_method  = dw_rtv.GetItemString(k,"gyul_method") 
		lstr_junpoy[il_AryCnt].taxgbn  = dw_rtv.GetItemString(k,"taxgbn") 
		lstr_junpoy[il_AryCnt].gita2  = dw_rtv.GetItemString(k,"gita2") 
	NEXT		
	
	lstr_jpra.flag =True
	
	closeWithReturn(parent,il_AryCnt)

END IF


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\선택_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\선택_up.gif"
end event

type p_inq from uo_picture within w_kglb01x
integer x = 3447
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;
String sSaupj,sDept,sBalDateFrom,sBalDateTo,sAcc
Long   lJunNo

dw_cond.AcceptText()
sSaupj       = dw_cond.GetItemString(dw_cond.GetRow(),"saupj")
sDept        = dw_cond.GetItemString(dw_cond.GetRow(),"dept_cd")
sBalDateFrom = dw_cond.GetItemString(dw_cond.GetRow(),"sdate")
sBalDateTo   = dw_cond.GetItemString(dw_cond.GetRow(),"edate")

IF sSaupj = "" or IsNull(sSaupj) THEN
   F_MessageChk(1,"[사업장]")
   dw_cond.SetColumn("saupj")
	dw_cond.SetFocus()
	return
END IF

IF sDept = "" or IsNull(sDept) THEN
	sDept = '%'
//   F_MessageChk(1,"[부서]")
//   dw_cond.SetColumn("dept_cd")
//	dw_cond.SetFocus()
//	return
END IF

IF sBalDateFrom = "" or IsNull(sBalDateFrom) THEN
   F_MessageChk(1,"[작성일자(from)]")
   dw_cond.SetColumn("sdate")
	dw_cond.SetFocus()
	return
END IF

IF sBalDateTo = "" or IsNull(sBalDateTo) THEN
   F_MessageChk(1,"[작성일자(to)]")
   dw_cond.SetColumn("edate")
	dw_cond.SetFocus()
	return
END IF

IF sBalDateFrom > sBalDateto THEN
   MessageBox("확 인", "날짜의 범위 지정이 잘못되었습니다! 작성일자를 확인하십시오")
	dw_cond.SetColumn("sdate")
	dw_cond.SetFocus()
	return
END IF

IF lstr_jpra.acc1 = "" OR IsNull(lstr_jpra.acc1) THEN
	sAcc = '%'
ELSE
	sAcc = lstr_jpra.acc1 + lstr_jpra.acc2
END IF

dw_2.SetRedraw(False)

dw_2.Reset()
IF dw_2.Retrieve(sSaupj,sDept,sBalDateFrom,sBalDateTo,sAcc,lstr_jpra.jun_gu) <=0 THEN
   F_MessageChk(14,'')
	
	dw_cond.SetColumn("sdate")
	dw_cond.SetFocus()
	
	dw_2.SetRedraw(True)
   return
end if

dw_2.SetRedraw(True)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type dw_rtv from datawindow within w_kglb01x
boolean visible = false
integer x = 1065
integer y = 2444
integer width = 1106
integer height = 124
boolean titlebar = true
string title = "미승인전표 라인별 조회"
string dataobject = "dw_kglc013"
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from u_d_select_sort within w_kglb01x
integer x = 41
integer y = 164
integer width = 3730
integer height = 1820
integer taborder = 30
string dataobject = "dw_kglb01x2"
boolean border = false
end type

event doubleclicked;
If Row <= 0 then
   return
END IF

lstr_jpra.saupjang  = dw_2.GetItemString(Row, "saupj")
lstr_jpra.baldate   = dw_2.GetItemString(Row, "bal_date")
lstr_jpra.upmugu    = dw_2.GetItemString(Row, "upmu_gu")
lstr_jpra.bjunno    = dw_2.GetItemNumber(Row, "bjun_no")

Open(w_kglc01a)

w_mdi_frame.sle_msg.text = '전표를 상세히 보고자 할 때 Double Click하십시오.!!'
end event

event clicked;call super::clicked;
IF Row <=0 THEN Return

SelectRow(0,False)
SelectRow(row,True)

lstr_jpra.flag = False

end event

type dw_cond from datawindow within w_kglb01x
event ue_pressenter pbm_dwnprocessenter
integer x = 18
integer y = 4
integer width = 3374
integer height = 136
integer taborder = 10
string dataobject = "dw_kglb01x1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;
Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;
Return 1
end event

event getfocus;this.AcceptText()
end event

event itemchanged;String  sSaupj,  sDate,sDeptCode,sDeptName,sNull
Integer iCurRow

SetNull(snull)

iCurRow = this.GetRow()

this.AcceptText()
IF this.GetColumnName() = "saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN RETURN
	
	IF IsNull(F_Get_Refferance('AD',sSaupj)) THEN
		F_MessageChk(20,'[사업장]')
		this.SetItem(iCurRow,"saupj",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "dept_cd" THEN
	sDeptCode = this.GetText()
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN Return
	
	sDeptName = F_Get_PersonLst('3',sDeptCode,'1')
	IF IsNull(sDeptName) THEN
		F_MessageChk(20,'[작성부서]')
		this.SetItem(iCurRow,"dept_cd",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "sdate" THEN
	sDate = Trim(this.GetText())
	IF sDate = "" OR IsNull(sDate) THEN RETURN
	
	IF F_DateChk(sDate) = -1 THEN
		F_MessageChk(21,'[작성일자]')
		this.SetItem(iCurRow,"sdate",snull)
		Return 1
	ELSE
		p_inq.TriggerEvent(Clicked!)
	END IF
END IF

IF this.GetColumnName() = "edate" THEN
	sDate = Trim(this.GetText())
	IF sDate = "" OR IsNull(sDate) THEN RETURN
	
	IF F_DateChk(sDate) = -1 THEN
		F_MessageChk(21,'[작성일자]')
		this.SetItem(iCurRow,"edate",snull)
		Return 1
	ELSE
		p_inq.TriggerEvent(Clicked!)
	END IF
END IF


end event

type rr_1 from roundrectangle within w_kglb01x
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 156
integer width = 3758
integer height = 1844
integer cornerheight = 40
integer cornerwidth = 55
end type

