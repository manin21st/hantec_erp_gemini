$PBExportHeader$w_pdm11711_popup.srw
$PBExportComments$단가 일괄 생성
forward
global type w_pdm11711_popup from w_inherite_popup
end type
type cbx_1 from checkbox within w_pdm11711_popup
end type
type st_2 from statictext within w_pdm11711_popup
end type
type rr_1 from roundrectangle within w_pdm11711_popup
end type
end forward

global type w_pdm11711_popup from w_inherite_popup
integer x = 1285
integer y = 148
integer width = 2309
integer height = 2096
string title = "단가 일괄 생성"
boolean controlmenu = true
cbx_1 cbx_1
st_2 st_2
rr_1 rr_1
end type
global w_pdm11711_popup w_pdm11711_popup

on w_pdm11711_popup.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.st_2=create st_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_pdm11711_popup.destroy
call super::destroy
destroy(this.cbx_1)
destroy(this.st_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.insertrow(0)
dw_1.retrieve()

dw_jogun.setfocus()


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_pdm11711_popup
integer y = 24
integer width = 1911
integer height = 712
string dataobject = "d_pdm11711_popup"
end type

event dw_jogun::itemchanged;call super::itemchanged;choose case this.getcolumnname()
	case 'sunwi_1'
		if 	this.gettext() > '6' then
			this.settext('')
			return 1
		else
			if	integer(this.gettext()) <> 0 	then
				if 	this.getitemnumber(row,'sunwi_2') = integer(this.gettext()) or &
					this.getitemnumber(row,'sunwi_3') = integer(this.gettext()) or &
					this.getitemnumber(row,'sunwi_4') = integer(this.gettext()) or &
					this.getitemnumber(row,'sunwi_5') = integer(this.gettext()) or &
					this.getitemnumber(row,'sunwi_6') = integer(this.gettext()) then
					messagebox('Error','순위가 중복으로 입력되었습니다.')
					this.settext('')
					return 1
				end if
			end if
		end if
	case 'sunwi_2'
		if this.gettext() > '6' then
			this.settext('')
			return 1
		else
			if	integer(this.gettext()) <> 0 	then
				if    this.getitemnumber(row,'sunwi_1') = integer(this.gettext()) or &
					this.getitemnumber(row,'sunwi_3') = integer(this.gettext()) or &
					this.getitemnumber(row,'sunwi_4') = integer(this.gettext()) or &
					this.getitemnumber(row,'sunwi_5') = integer(this.gettext()) or &
					this.getitemnumber(row,'sunwi_6') = integer(this.gettext()) then
					messagebox('Error','순위가 중복으로 입력되었습니다.')
					this.settext('')
					return 1
				end if
			End if
		end if
	case 'sunwi_3'
		if this.gettext() > '6' then
			this.settext('')
			return 1
		else
			if	integer(this.gettext()) <> 0 	then
				if 	this.getitemnumber(row,'sunwi_2') = integer(this.gettext()) or &
					this.getitemnumber(row,'sunwi_1') = integer(this.gettext()) or &
					this.getitemnumber(row,'sunwi_4') = integer(this.gettext()) or &
					this.getitemnumber(row,'sunwi_5') = integer(this.gettext()) or &
					this.getitemnumber(row,'sunwi_6') = integer(this.gettext()) then
					messagebox('Error','순위가 중복으로 입력되었습니다.')
					this.settext('')
					return 1
				end if
			End if
		end if
	case 'sunwi_4'
		if this.gettext() > '6' then
			this.settext('')
			return 1
		else
			if	integer(this.gettext()) <> 0 	then
				if 	this.getitemnumber(row,'sunwi_2') = integer(this.gettext()) or &
					this.getitemnumber(row,'sunwi_3') = integer(this.gettext()) or &
					this.getitemnumber(row,'sunwi_1') = integer(this.gettext()) or &
					this.getitemnumber(row,'sunwi_5') = integer(this.gettext()) or &
					this.getitemnumber(row,'sunwi_6') = integer(this.gettext()) then
					messagebox('Error','순위가 중복으로 입력되었습니다.')
					this.settext('')
					return 1
				end if
			End if
		end if
	case 'sunwi_5'
		if this.gettext() > '6' then
			this.settext('')
			return 1
		else
			if	integer(this.gettext()) <> 0 	then
				if 	this.getitemnumber(row,'sunwi_2') = integer(this.gettext()) or &
					this.getitemnumber(row,'sunwi_3') = integer(this.gettext()) or &
					this.getitemnumber(row,'sunwi_4') = integer(this.gettext()) or &
					this.getitemnumber(row,'sunwi_1') = integer(this.gettext()) or &
					this.getitemnumber(row,'sunwi_6') = integer(this.gettext()) then
					messagebox('Error','순위가 중복으로 입력되었습니다.')
					this.settext('')
					return 1
				end if
			End if
		end if
	case 'sunwi_6'
		if this.gettext() > '6' then
			this.settext('')
			return 1
		else
			if	integer(this.gettext()) <> 0 	then
				if 	this.getitemnumber(row,'sunwi_2') = integer(this.gettext()) or &
					this.getitemnumber(row,'sunwi_3') = integer(this.gettext()) or &
					this.getitemnumber(row,'sunwi_4') = integer(this.gettext()) or &
					this.getitemnumber(row,'sunwi_5') = integer(this.gettext()) or &
					this.getitemnumber(row,'sunwi_1') = integer(this.gettext()) then
					messagebox('Error','순위가 중복으로 입력되었습니다.')
					this.settext('')
					return 1
				end if
			End if
		end if
END CHOOSE
//String scode, s_name, snull
//
//setnull(snull)
//
//IF this.GetColumnName() ="code2" THEN
//	scode = this.GetText()
//
//   IF scode = "" OR IsNull(scode) THEN RETURN
//	
//    SELECT "SAREA"."SAREA"  
//      INTO :s_name  
//      FROM "SAREA"  
//     WHERE "SAREA"."SAREA" = :scode   ;
//
//	if isnull(s_name) or s_name="" then
//		f_message_chk(33,'[관할구역]')
//		this.SetItem(1,'code2', snull)
//		return 1
//   end if	
//	
////	gs_area = scode
//	
//END IF
end event

event dw_jogun::itemerror;call super::itemerror;return 1
end event

type p_exit from w_inherite_popup`p_exit within w_pdm11711_popup
integer x = 2117
integer y = 16
integer taborder = 60
end type

event p_exit::clicked;call super::clicked;Closewithreturn(Parent,'0')
end event

type p_inq from w_inherite_popup`p_inq within w_pdm11711_popup
boolean visible = false
integer x = 1673
integer y = 16
end type

event p_inq::clicked;call super::clicked;String scode,sname,sgubun, sgubun2 

if dw_jogun.AcceptText() = -1 then return 

sgubun = dw_jogun.GetItemString(1,"code1")
sgubun2 = dw_jogun.GetItemString(1,"code2")
scode = dw_jogun.GetItemString(1,"code")
sname = dw_jogun.GetItemString(1,"name")

IF sgubun ="" OR IsNull(sgubun) THEN
	sgubun ='%'
END IF

IF sgubun2 ="" OR IsNull(sgubun2) THEN
	sgubun2 ='%'
END IF

IF IsNull(scode) THEN
	scode ="%"
ELSE 
	scode = scode + '%'
END IF

IF IsNull(sname) THEN
	sname ="%"
ELSE 
	sname = "%" + sname + '%'
END IF

dw_1.Retrieve(scode, sname, sgubun, sgubun2)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.setfocus()


end event

type p_choose from w_inherite_popup`p_choose within w_pdm11711_popup
integer x = 1943
integer y = 16
integer taborder = 40
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_choose::clicked;call super::clicked;string ls_value,ls_sijak_date,ls_maeip_from,ls_maeip_to
String ls_ittyp,ls_itcls,ls_itnbr,ls_itdsc,ls_jijil,ls_ispec,ls_porgu
string ls_cvcod[50]

int li_jeokyoung_rate,li_sunwi_1,li_sunwi_2,li_sunwi_3,li_sunwi_4,li_sunwi_5,li_sunwi_6
//적용시작일 체크

if dw_jogun.accepttext() = -1 then
	dw_jogun.setfocus()
	return
end if


ls_sijak_date 	= dw_jogun.getitemstring(dw_jogun.getrow(),'sijak_date')
ls_maeip_from 	= dw_jogun.getitemstring(dw_jogun.getrow(),'maeip_from')
ls_maeip_to 		= dw_jogun.getitemstring(dw_jogun.getrow(),'maeip_to')
li_jeokyoung_rate = dw_jogun.getitemnumber(dw_jogun.getrow(),'jeokyoung_rate')
//li_sunwi_1 = dw_jogun.getitemnumber(dw_jogun.getrow(),'sunwi_1')
//li_sunwi_2 = dw_jogun.getitemnumber(dw_jogun.getrow(),'sunwi_2')
//li_sunwi_3 = dw_jogun.getitemnumber(dw_jogun.getrow(),'sunwi_3')
//li_sunwi_4 = dw_jogun.getitemnumber(dw_jogun.getrow(),'sunwi_4')
//li_sunwi_5 = dw_jogun.getitemnumber(dw_jogun.getrow(),'sunwi_5')
//li_sunwi_6 = dw_jogun.getitemnumber(dw_jogun.getrow(),'sunwi_6')
//li_sunwi_1 = dw_jogun.getitemnumber(dw_jogun.getrow(),'sunwi_1')
li_sunwi_1 = dw_jogun.getitemnumber(1,'sunwi_1')
li_sunwi_2 = dw_jogun.getitemnumber(1,'sunwi_2')
li_sunwi_3 = dw_jogun.getitemnumber(1,'sunwi_3')
li_sunwi_4 = dw_jogun.getitemnumber(1,'sunwi_4')
li_sunwi_5 = dw_jogun.getitemnumber(1,'sunwi_5')
li_sunwi_6 = dw_jogun.getitemnumber(1,'sunwi_6')

if 	isnull(ls_sijak_date) or trim(ls_sijak_date) = '' then
	f_message_chk(30,'[적용시작일]')
	dw_jogun.setcolumn('sijak_date')
	dw_jogun.setfocus()
	return
end if
if 	isnull(ls_maeip_from) or trim(ls_maeip_from) = '' then
	f_message_chk(30,'[매입기간(from)]')
	dw_jogun.setcolumn('maeip_from')
	dw_jogun.setfocus()
	return
end if
if 	isnull(ls_maeip_to) or trim(ls_maeip_to) = '' then
	f_message_chk(30,'[매입기간(to)]')
	dw_jogun.setcolumn('maeip_to')
	dw_jogun.setfocus()
	return
end if

ls_ittyp 	= trim(mid(message.stringparm,1,1))
ls_itcls 	= trim(mid(message.stringparm,2,7))
ls_itnbr 	= trim(mid(message.stringparm,9,15))
ls_itdsc 	= trim(mid(message.stringparm,24,40))
ls_jijil 		= trim(mid(message.stringparm,64,40))
ls_ispec 	= trim(mid(message.stringparm,104,40))
ls_porgu 	= trim(mid(message.stringparm,144,6))

pointer oldpointer
oldpointer = SetPointer(HourGlass!)

DECLARE PDM11711_POPUP CURSOR FOR
	SELECT ITNBR,SUM(MAX_PRC) b,SUM(AVG_PRC),SUM(MIN_PRC),SUM(GAE_PRC),SUM(GU_PRC),SUM(LAST_PRC)
	FROM (
		SELECT ITNBR,MAX(NVL(IOPRC,0)) MAX_PRC,ROUND(AVG(NVL(IOPRC,0)),0) AVG_PRC,MIN(NVL(IOPRC,0)) MIN_PRC,0 GAE_PRC,0 GU_PRC,0 LAST_PRC
		FROM IMHIST
		WHERE SUDAT BETWEEN :ls_maeip_from AND :ls_maeip_to AND
				SABU = :gs_sabu AND
				IOGBN = 'I01' AND
				ITNBR IN	  (SELECT ITNBR
								FROM ITEMAS A,ITNCT B
								WHERE A.ITTYP = :ls_ittyp AND  
									  A.ITCLS like :ls_itcls AND  
									  A.ITNBR like :ls_itnbr AND  
									  A.ITDSC like :ls_itdsc AND  
									  nvl(A.JIJIL,' ') like :ls_jijil AND  
									  nvl(A.ISPEC,' ') like :ls_ispec AND
									  A.USEYN = '0' AND
									  A.SABU = :gs_sabu AND
									  B.ITTYP = A.ittyp AND
									  B.ITCLS = A.itcls AND
									  B.PORGU = :ls_porgu)
		GROUP BY ITNBR
		UNION ALL
		SELECT ITNBR,0 MAX_PRC,0 AVG_PRC,0 MIN_PRC,MAX(NVL(UNPRC,0)) GAE_PRC,0 GU_PRC,0 LAST_PRC
		FROM DANMST
		WHERE CNTGU = '1' AND
				GUOUT = '1' AND
				(EFRDT BETWEEN :ls_maeip_from AND :ls_maeip_to OR
				EFTDT BETWEEN :ls_maeip_from AND :ls_maeip_to) AND
				ITNBR IN (  SELECT ITNBR
								FROM ITEMAS A,ITNCT B
								WHERE A.ITTYP = :ls_ittyp AND  
									  A.ITCLS like :ls_itcls AND  
									  A.ITNBR like :ls_itnbr AND  
									  A.ITDSC like :ls_itdsc AND  
									  nvl(A.JIJIL,' ') like :ls_jijil AND  
									  nvl(A.ISPEC,' ') like :ls_ispec AND
									  A.USEYN = '0' AND
									  A.SABU = :gs_sabu AND
									  B.ITTYP = A.ittyp AND
									  B.ITCLS = A.itcls AND
									  B.PORGU = :ls_porgu)
		GROUP BY ITNBR
		UNION ALL
		SELECT ITNBR,0 MAX_PRC,0 AVG_PRC,0 MIN_PRC,0 GAE_PRC,NVL(WONPRC,0) GU_PRC,0 LAST_PRC
		FROM ITEMAS A,ITNCT B
		WHERE A.ITTYP = :ls_ittyp AND  
			  A.ITCLS like :ls_itcls AND  
			  A.ITNBR like :ls_itnbr AND  
			  A.ITDSC like :ls_itdsc AND  
			  nvl(A.JIJIL,' ') like :ls_jijil AND  
			  nvl(A.ISPEC,' ') like :ls_ispec AND
			  A.USEYN = '0'AND
			  A.SABU = :gs_sabu AND
			  B.ITTYP = A.ittyp AND
			  B.ITCLS = A.itcls AND
			  B.PORGU = :ls_porgu
		UNION ALL
		SELECT ITNBR,0 MAX_PRC,0 AVG_PRC,0 MIN_PRC,0 GAE_PRC,0 GU_PRC, SUM(LAST_PRC)/COUNT(*)
		  FROM
    		(SELECT ITNBR,fun_get_imhist_lastdan(sabu,cvcod,itnbr,pspec) LAST_PRC
	        	FROM IMHIST
        		WHERE SUDAT BETWEEN :ls_maeip_from AND :ls_maeip_to AND
		    		SABU = :gs_sabu AND
			    	IOGBN = 'I01' AND
					IOPRC > 0     AND
				    ITNBR IN 	  (SELECT ITNBR
								FROM ITEMAS A,ITNCT B
								WHERE A.ITTYP = :ls_ittyp AND  
									  A.ITCLS like :ls_itcls AND  
									  A.ITNBR like :ls_itnbr AND  
									  A.ITDSC like :ls_itdsc AND  
									  nvl(A.JIJIL,' ') like :ls_jijil AND  
									  nvl(A.ISPEC,' ') like :ls_ispec AND
									  A.USEYN = '0' AND
									  A.SABU = :gs_sabu AND
									  B.ITTYP = A.ittyp AND
									  B.ITCLS = A.itcls AND
									  B.PORGU = :ls_porgu))
          GROUP by itnbr	
			) 
	GROUP BY ITNBR;		
OPEN PDM11711_POPUP;

double ld_MAX_PRC,ld_AVG_PRC,ld_MIN_PRC,ld_GAE_PRC,ld_GU_PRC,ld_LAST_PRC
string ls_O_ITNBR
int li_cnt,li_max_cnt


FETCH PDM11711_POPUP INTO :ls_O_ITNBR,:ld_MAX_PRC,:ld_AVG_PRC,:ld_MIN_PRC,:ld_GAE_PRC,:ld_GU_PRC,:ld_LAST_PRC;

// 선택된 거래처 값을 배열에 저장
IF SQLCA.SQLCODE = 0 THEN
	FOR li_cnt = 1 to dw_1.rowcount()
		IF dw_1.getitemstring(li_cnt,'chk') = 'Y' then
			li_max_cnt += 1
			IF li_max_cnt > 50 then
				SetPointer(oldpointer)				
				messagebox('Error','지정한 값을 초과하였습니다.전산실로 문의 하세요')
				Closewithreturn(Parent,'0')
			END IF
			ls_cvcod[li_max_cnt] = dw_1.getitemstring(li_cnt,'cvcod')
		END IF
	NEXT
END IF

double 	ld_prc[6],ld_org_prc
Integer	lcnt

DO WHILE SQLCA.SQLCODE = 0
	ld_prc[1]=0
	ld_prc[2]=0
	ld_prc[3]=0
	ld_prc[4]=0
	ld_prc[5]=0
	ld_prc[6]=0
	if li_sunwi_1 <> 0 then
		ld_prc[li_sunwi_1] = ld_max_prc
	end if
	if li_sunwi_2 <> 0 then
		ld_prc[li_sunwi_2] = ld_avg_prc
	end if
	if li_sunwi_3 <> 0 then
		ld_prc[li_sunwi_3] = ld_min_prc
	end if
	if li_sunwi_4 <> 0 then
		ld_prc[li_sunwi_4] = ld_gae_prc
	end if
	if li_sunwi_5 <> 0 then
		ld_prc[li_sunwi_5] = ld_gu_prc
	end if
	if li_sunwi_6 <> 0 then
		ld_prc[li_sunwi_6] = ld_last_prc
	end if
	
	ld_org_prc = 0
	FOR li_cnt = 1 to 6
		IF ld_prc[li_cnt] <> 0 then
			ld_org_prc = ld_prc[li_cnt]
			li_cnt = 6
		END IF
	NEXT
		
	FOR li_cnt = 1 to li_max_cnt
		Lcnt	= 0
		SELECT   	COUNT(*) INTO :Lcnt
			 FROM  	WSTRUC  WHERE CINBR = :ls_O_ITNBR	AND CVCOD = :ls_cvcod[li_cnt];
		If	Lcnt > 0	then
			
			Lcnt = 0
			Select count(*) into :Lcnt 
			  From wsunpr   where itnbr = :ls_O_ITNBR And cvcod = :ls_cvcod[li_cnt] And sdate = :ls_sijak_date;
			If 	Lcnt > 0 then
				update     wsunpr  Set unprc = :ld_org_prc * :li_jeokyoung_rate * 0.01
				     where itnbr = :ls_O_ITNBR And cvcod = :ls_cvcod[li_cnt] And sdate = :ls_sijak_date;
			else
				INSERT INTO WSUNPR(ITNBR,CVCOD,SDATE,UNPRC)
					VALUES(:ls_O_ITNBR,:ls_cvcod[li_cnt],:ls_sijak_date,:ld_org_prc * :li_jeokyoung_rate * 0.01);
			End if
			IF SQLCA.SQLCODE = -1 THEN
				SetPointer(oldpointer)			
				messagebox('Error','자료저장시 에러가 발생했습니다.')
				rollback;
//				Closewithreturn(Parent,'0')
			END IF
		End If
	NEXT	
	FETCH PDM11711_POPUP INTO :ls_O_ITNBR,:ld_MAX_PRC,:ld_AVG_PRC,:ld_MIN_PRC,:ld_GAE_PRC,:ld_GU_PRC,:ld_LAST_PRC;
LOOP		
CLOSE PDM11711_POPUP;

commit;

SetPointer(oldpointer)
Closewithreturn(Parent,'1')


end event

type dw_1 from w_inherite_popup`dw_1 within w_pdm11711_popup
integer x = 37
integer y = 804
integer width = 2217
integer height = 1176
integer taborder = 70
string dataobject = "d_pdm11711_popup1"
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	b_flag = False
END IF

CALL SUPER ::CLICKED

end event

event dw_1::doubleclicked;//IF Row <= 0 THEN
//   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
//   return
//END IF
//
//IF dw_1.getitemstring(row, "cvstatus") = '2' then 
//   MessageBox("확 인", "거래종료인 자료는 선택할 수 없습니다.")
//   return
//END IF
//
//gs_gubun= dw_1.GetItemString(Row, "cvgu")
//gs_code= dw_1.GetItemString(Row, "cvcod")
//gs_codename= dw_1.GetItemString(row,"cvnas2")
//
//Close(Parent)
//
end event

type sle_2 from w_inherite_popup`sle_2 within w_pdm11711_popup
boolean visible = false
integer x = 430
integer y = 2148
integer width = 1271
integer taborder = 50
boolean enabled = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_pdm11711_popup
integer x = 1097
integer y = 2064
integer taborder = 80
end type

type cb_return from w_inherite_popup`cb_return within w_pdm11711_popup
integer x = 1719
integer y = 2064
integer taborder = 110
end type

type cb_inq from w_inherite_popup`cb_inq within w_pdm11711_popup
integer x = 1408
integer y = 2064
integer taborder = 100
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_pdm11711_popup
boolean visible = false
integer x = 233
integer y = 2148
integer width = 197
integer taborder = 30
boolean enabled = false
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_pdm11711_popup
boolean visible = false
integer x = 128
integer y = 2148
integer width = 315
string text = "대리점코드"
end type

type cbx_1 from checkbox within w_pdm11711_popup
integer x = 1947
integer y = 712
integer width = 73
integer height = 72
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "none"
end type

event clicked;Long li_cnt

If this.Checked = True Then
	For li_cnt = 1 to dw_1.rowcount()
		 dw_1.setitem(li_cnt, 'chk','Y')
	Next
	st_2.text = '전체취소'
Else
	For li_cnt = 1 to dw_1.rowcount()
		 dw_1.Setitem(li_cnt, 'chk', 'N')
	Next
	st_2.text = '전체선택'
End if
end event

type st_2 from statictext within w_pdm11711_popup
integer x = 2021
integer y = 720
integer width = 261
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
string text = "전체선택"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pdm11711_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 788
integer width = 2240
integer height = 1212
integer cornerheight = 40
integer cornerwidth = 55
end type

