$PBExportHeader$w_kgle55.srw
$PBExportComments$자본변동표 등록
forward
global type w_kgle55 from w_standard_print
end type
type p_update from p_retrieve within w_kgle55
end type
type rr_1 from roundrectangle within w_kgle55
end type
end forward

global type w_kgle55 from w_standard_print
string title = "자본변동표 등록"
p_update p_update
rr_1 rr_1
end type
global w_kgle55 w_kgle55

forward prototypes
public function integer wf_retrieve ()
public function integer wf_create_kfz02wk3 ()
public subroutine wf_calc_auto ()
end prototypes

public function integer wf_retrieve ();String    s_saupj, sFrYmdD, sToYmdD,sCrtGbn ='0'
Integer  Id_Ses,iRow 

w_mdi_frame.sle_msg.text =""

dw_ip.AcceptText()

s_saupj = dw_ip.GetItemString(dw_ip.Getrow(),"saupj")
Id_Ses  = dw_ip.getItemNumber(dw_ip.Getrow(),"d_ses")
sFrYmdD = Trim(dw_ip.GetItemString(dw_ip.Getrow(),"d_frymd"))
sToYmdD = Trim(dw_ip.GetItemString(dw_ip.Getrow(),"d_toymd"))

IF s_saupj ="" OR IsNull(s_saupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

IF dw_ip.GetItemString(dw_ip.Getrow(),"d_frymd") ="" OR 	IsNull(dw_ip.GetItemString(dw_ip.Getrow(),"d_frymd")) THEN
	w_mdi_frame.sle_msg.text ="회기가 등록되지 않았습니다. 먼저 회기를 등록하세요.!!"
	MessageBox("확 인","회기를 입력하세요.!!")
	Return -1
END IF

iRow = dw_list.Retrieve(s_saupj,sFrYmdD,sToYmdD,Id_Ses)

if iRow  > 0 then
	if MessageBox('확 인','생성된 자료가 있습니다.삭제 후 다시 생성하시겠습니까?',Question!,YesNo!) = 1 then
		delete from kfz02wk3 where saupj = :s_saupj	and fromymd = :sFrYmdD and toymd = :sToYmdD and dses = :Id_Ses ;
		commit ;
		sCrtGbn = '1'
	else
		sCrtGbn = '0'
	end if
else
	sCrtGbn = '1'
end if

if sCrtGbn = '1' then
	if Wf_Create_kfz02wk3() = -1 then
		rollback;
	else
		commit;
		
		dw_list.Retrieve(s_saupj,sFrYmdD,sToYmdD,Id_Ses)
		Wf_Calc_Auto()
		
		dw_list.Update()
		commit;
	end if
end if

Return 1
end function

public function integer wf_create_kfz02wk3 ();String   sGubun,sName, sCalcAcc, sCalcGbn,sAcc[], sSaupj, sBefYm,sFromYmd,sToYmd
Integer  iBuho,k, lDses
Double   dAmt[]

sSaupj   = dw_ip.GetItemString(dw_ip.Getrow(),"saupj")
lDses    = dw_ip.getItemNumber(dw_ip.Getrow(),"d_ses")
sFromYmd = Trim(dw_ip.GetItemString(dw_ip.Getrow(),"d_frymd"))
sToYmd   = Trim(dw_ip.GetItemString(dw_ip.Getrow(),"d_toymd"))

sBefYm = Left(sFromYmd,4) + String(Integer(Mid(sFromYmd,5,2)) - 1,'00')

w_mdi_frame.sle_msg.text ='자료 생성 중...'
SetPointer(Hourglass!)

DECLARE CUR_LIST CURSOR FOR  
	SELECT "RFGUB",   "RFNA1",    "RFNA2"||nvl("RFNA3",'') as calc_acc,   "RFNA5" as calc_gbn,  "RFNA4" as buho
	 	FROM "REFFPF"  
		WHERE ( "RFCOD" = 'FC' ) AND ( "RFGUB" <> '00' ) ORDER BY  "RFGUB" ;
		
Open CUR_LIST ;

Do While True
	Fetch CUR_LIST into :sGubun,	:sName,	:sCalcAcc,	:sCalcGbn,  :iBuho ;
	if sqlca.sqlcode <> 0 then exit
	
	if sCalcGbn = '1' then				//읽어옴
		sAcc[1] = Left(sCalcAcc,7)		//자본금	
		sAcc[2] = Mid(sCalcAcc,8,7)	//자본잉여금
		sAcc[3] = Mid(sCalcAcc,15,7)	//자본조정
		sAcc[4] = Mid(sCalcAcc,22,7)	//기타포괄
		sAcc[5] = Mid(sCalcAcc,29,7)	//이익잉여금
		
		for k = 1 to 5		
			if sAcc[k] = '0000000' then		
				dAmt[k] = 0
			else
				if sGubun = '00001' then					//이월
					select sum(nvl(cr_amt,0) - nvl(dr_amt,0)) into :dAmt[k] 
						from kfz14ot0
						where saupj = :sSaupj and acc_yy||acc_mm >= substr(:sBefYm,1,4)||'00' and acc_yy||acc_mm <= :sBefYm and
								acc1_cd||acc2_cd = :sAcc[k] ;
				else
					select sum(nvl(cr_amt,0)) into :dAmt[k] 
						from kfz14ot0
						where saupj = :sSaupj and acc_yy||acc_mm >= substr(:sFromYmd,1,6) and acc_yy||acc_mm <= substr(:sToYmd,1,6) and
								acc1_cd||acc2_cd = :sAcc[k] ;
				end if
				if sqlca.sqlcode <> 0 then
					dAmt[k] = 0
				else
					if IsNull(dAmt[k]) then dAmt[k] = 0
				end if				
				dAmt[k] = dAmt[k] * iBuho
			end if			
		next
	else										//직접입력&계산
		dAmt[1] = 0
		dAmt[2] = 0
		dAmt[3] = 0
		dAmt[4] = 0
		dAmt[5] = 0
	end if;
	
	if sGubun = '00001' then		//이월
		sName = String(sFromYmd,'@@@@.@@.@@')+' '+sName 
	elseif sGubun = '99999' then		//합계
		sName = String(sToYmd,'@@@@.@@.@@')
	end if
		
	insert into kfz02wk3
		( saupj,			fromymd,			toymd,		dses,			gubun,			gubun_nm,	
		  amt1,			amt2,				amt3,			amt4,			amt5,				
		  amth)
	values
		( :sSaupj,		:sFromYmd,		:sToYmd,		:lDses,		:sGubun,			:sName,		
		  :dAmt[1],		:dAmt[2],		:dAmt[3],	:dAmt[4],	:dAmt[5],		
		  :dAmt[1] + :dAmt[2] + :dAmt[3] + :dAmt[4] + :dAmt[5]) ;
	if sqlca.sqlcode <> 0 then
		rollback;
		return -1
	end if
Loop
Close CUR_LIST;

return 1
end function

public subroutine wf_calc_auto ();
Integer    k, iRowCount, i, iFindRow
String     sEditGbn,sGubun,sCalc[],sAcc[],sCalcAcc
Double     dAmt1, dAmt2, dAmt3, dAmt4, dAmt5, dAmtH, dAmt, dAmtSum1,dAmtSum2,dAmtSum3,dAmtSum4,dAmtSum5,dAmtSumH
dw_list.AcceptText()

w_mdi_frame.sle_msg.text = '자동 계산 중...'
SetPointer(HourGlass!)

dw_list.AcceptText()

iRowCount = dw_list.RowCount()
For k = 1 To iRowCount
	sEditGbn = dw_list.GetItemString(k,"calc_gbn")
	sGubun   = dw_list.GetItemString(k,"gubun")
	
	if sEditGbn = '3' then 		/*자동계산*/
		if sGubun = '99999' then				//합계
			dAmtSum1 = dw_list.GetItemNumber(1,"hap_amt1")	
			dAmtSum2 = dw_list.GetItemNumber(1,"hap_amt2")	
			dAmtSum3 = dw_list.GetItemNumber(1,"hap_amt3")	
			dAmtSum4 = dw_list.GetItemNumber(1,"hap_amt4")	
			dAmtSum5 = dw_list.GetItemNumber(1,"hap_amt5")	
			dAmtSumH = dw_list.GetItemNumber(1,"hap_amth")	
		else
			sCalcAcc = dw_list.GetItemString(k,"calc_acc")
			
			sCalc[1] = '+'	
			sAcc[1]  = Left(sCalcAcc,5)
			
			sCalc[2] = Mid(sCalcAcc,6,1)
			sAcc[2]  = Mid(sCalcAcc,7,5)
			
			sCalc[3] = Mid(sCalcAcc,12,1)	
			sAcc[3]  = Mid(sCalcAcc,13,5)
			
			For i = 1 To 3
				if sAcc[i] = '' or IsNull(sAcc[i]) or sAcc[i] = '00000' then
					dAmt1 = 0;		dAmt2 = 0;   dAmt3 = 0;		dAmt4 = 0;		dAmt5 = 0;		dAmth = 0;
				else
					dAmt1 = 0;		dAmt2 = 0;   dAmt3 = 0;		dAmt4 = 0;
					
					iFindRow = dw_list.Find("str_gubun = '"+sAcc[i]+"'",1,iRowCount)
					if iFindRow > 0 then
						dAmt5 = dw_list.GetItemNumber(iFindRow,"amt5")
						dAmth = dw_list.GetItemNumber(iFindRow,"amth")
						if IsNull(dAmt5) then dAmt5 = 0
						if IsNull(dAmth) then dAmth = 0
					else
						dAmt5 = 0;		dAmth = 0;
					end if					
				end if
				
				if sCalc[i] = '+' then
					dAmtSum1 = dAmtSum1 + dAmt1
					dAmtSum2 = dAmtSum2 + dAmt2
					dAmtSum3 = dAmtSum3 + dAmt3
					dAmtSum4 = dAmtSum4 + dAmt4
					dAmtSum5 = dAmtSum5 + dAmt5
					dAmtSumH = dAmtSumH + dAmtH
				elseif sCalc[i] = '-' then
					dAmtSum1 = dAmtSum1 - dAmt1
					dAmtSum2 = dAmtSum2 - dAmt2
					dAmtSum3 = dAmtSum3 - dAmt3
					dAmtSum4 = dAmtSum4 - dAmt4
					dAmtSum5 = dAmtSum5 - dAmt5
					dAmtSumH = dAmtSumH - dAmtH
				end if
			Next
		end if
		
		dw_list.SetItem(k, "amt1", dAmtSum1)	
		dw_list.SetItem(k, "amt2", dAmtSum2)	
		dw_list.SetItem(k, "amt3", dAmtSum3)	
		dw_list.SetItem(k, "amt4", dAmtSum4)	
		dw_list.SetItem(k, "amt5", dAmtSum5)	
		dw_list.SetItem(k, "amth", dAmtSumH)		
	else
		dAmtSum1 = dw_list.GetItemNumber(k,"sumh")	
		
		dw_list.SetItem(k, "amth", dAmtSum1)	
	end if	
	
	dAmtSum1 = 0;		dAmtSum2 =0;		dAmtSum3 =0;	dAmtSum4 =0;	dAmtSum5 =0;	dAmtSumH =0;
	dAmt1 = 0;			dAmt2 =0;			dAmt3 =0;		dAmt4 =0;		dAmt5 =0;		dAmtH =0;
	
Next
w_mdi_frame.sle_msg.text = '자동 계산 완료'
SetPointer(Arrow!)


end subroutine

on w_kgle55.create
int iCurrent
call super::create
this.p_update=create p_update
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_update
this.Control[iCurrent+2]=this.rr_1
end on

on w_kgle55.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_update)
destroy(this.rr_1)
end on

event open;call super::open;String sMaxDate,sCurrF,sCurrT,sPrvF,sPrvT
Long   lCurr,lPrv

dw_ip.SetItem(dw_ip.GetRow(),"saupj",gs_saupj)

dw_ip.Setcolumn("saupj")
dw_ip.SetFocus()

SELECT MAX("CURR_FROM_DATE"||"CURR_TO_DATE"||"PRV_FROM_DATE"||"PRV_TO_DATE")
	INTO :sMaxDate
   FROM "KFZ02WK"   WHERE "SAUPJ" = :Gs_Saupj ;
IF SQLCA.SQLCODE <> 0 OR sMaxDate = '' or IsNull(sMaxDate) THEN
	select d_ses,		d_frymd,		d_toymd,		j_ses,		j_frymd,		j_toymd
		into :lCurr,	:sCurrF,		:sCurrT,		:lPrv,		:sPrvF,		:sPrvT
    	from kfz08om0 ;
	
ELSE
	sCurrF = Left(sMaxDate,8);		sCurrT = Mid(sMaxDate,9,8);
	sPrvF  = Mid(sMaxDate,17,8);  sPrvT  = Right(sMaxDate,8);

	SELECT "CURR_YEAR",   "PRV_YEAR"		INTO :lCurr,		 :lPrv
		FROM "KFZ02WK"  
		WHERE "SAUPJ" = :Gs_Saupj AND
				"CURR_FROM_DATE" = :sCurrF AND "CURR_TO_DATE" = :sCurrT AND
				"PRV_FROM_DATE"  = :sPrvF AND  "PRV_TO_DATE"  = :sPrvT ;
END IF

dw_ip.SetItem(1,"d_ses",   lCurr)
dw_ip.SetItem(1,"d_frymd", sCurrF)
dw_ip.SetItem(1,"d_toymd", sCurrT)

dw_print.Sharedataoff()
dw_list.Sharedataoff()

dw_list.SetTransObject(Sqlca)

end event

type p_xls from w_standard_print`p_xls within w_kgle55
end type

type p_sort from w_standard_print`p_sort within w_kgle55
end type

type p_preview from w_standard_print`p_preview within w_kgle55
boolean visible = false
integer x = 2615
integer y = 4
integer taborder = 0
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_kgle55
integer y = 16
integer taborder = 40
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_kgle55
boolean visible = false
integer x = 2807
integer y = 8
integer taborder = 0
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgle55
integer x = 4096
integer y = 16
string pointer = ""
end type

type st_window from w_standard_print`st_window within w_kgle55
integer x = 2377
integer width = 462
end type

type sle_msg from w_standard_print`sle_msg within w_kgle55
integer width = 1984
end type

type dw_datetime from w_standard_print`dw_datetime within w_kgle55
integer x = 2839
end type

type st_10 from w_standard_print`st_10 within w_kgle55
end type

type gb_10 from w_standard_print`gb_10 within w_kgle55
integer width = 3584
end type

type dw_print from w_standard_print`dw_print within w_kgle55
integer x = 3515
integer y = 12
integer width = 119
integer height = 120
string dataobject = "dw_kgle55_1"
end type

type dw_ip from w_standard_print`dw_ip within w_kgle55
integer x = 46
integer y = 24
integer width = 2501
integer height = 156
string dataobject = "dw_kgle55_0"
end type

event dw_ip::itemchanged;
IF dwo.name ="gubun" THEN
	dw_list.SetRedraw(False)

	IF data ='4' THEN
		dw_list.DataObject ="dw_kgle01_4"
		dw_print.DataObject ="dw_kgle01_4_p"
		
		p_update.Enabled = True
		p_update.PictureName = 'C:\erpman\image\저장_up.gif'
	ELSE
		dw_list.DataObject ="dw_kgle01_1"
		dw_print.DataObject ="dw_kgle01_1_p"
		
		p_update.Enabled = True
		p_update.PictureName = 'C:\erpman\image\저장_d.gif'
	END IF
	dw_list.SetRedraw(True)
	
	dw_list.SetTransObject(SQLCA)	
	dw_print.SetTransObject(sqlca)
END IF

end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::getfocus;this.AcceptText()
end event

event dw_ip::rbuttondown;String   sNull
Integer  lNull

SetNull(sNull);	SetNull(lNull);

this.AcceptText()
IF this.GetColumnName() = 'd_ses' THEN
	SetNull(Gs_Code);			SetNull(Gs_Gubun)
	
	Gs_Gubun = this.GetItemString(this.GetRow(),"saupj")
	
	Gs_Code = String(this.GetItemNumber(this.GetRow(),"d_ses"))
	IF IsNull(Gs_Code) THEN Gs_Code = ''
	
	Open(W_kfz02wk_popup)
	
	IF IsNull(Gs_Code) OR Gs_Code = '' THEN Return
		
	this.SetItem(1,"d_ses",   Integer(Left(Gs_Code,3)))
	this.SetItem(1,"d_frymd", Mid(Gs_Code,4,8))
	this.SetItem(1,"d_toymd", Mid(Gs_Code,12,8))
	
	this.SetItem(1,"j_ses",   Integer(Mid(Gs_Code,20,3)))
	this.SetItem(1,"j_frymd", Mid(Gs_Code,23,8))
	this.SetItem(1,"j_toymd", Mid(Gs_Code,31,8))

	this.SetColumn("gubun")
	this.SetFocus()
END IF

end event

type dw_list from w_standard_print`dw_list within w_kgle55
integer x = 78
integer y = 200
integer width = 4498
integer height = 2008
integer taborder = 0
string dataobject = "dw_kgle55_1"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::itemchanged;call super::itemchanged;Integer iBuho
Double  dAmt

iBuho = this.GetItemNumber(this.GetRow(),"buho")
if iBuho = 0 or IsNull(iBuho) then iBuho = 0

if this.GetColumnName() = 'amt1' then
	dAmt = Double(this.GetText())
	if IsNull(dAmt) then dAmt = 0
	
	this.SetItem(this.GetRow(),"amt1", dAmt * iBuho)
//	return 2
end if

if this.GetColumnName() = 'amt2' then
	dAmt = Double(this.GetText())
	if IsNull(dAmt) then dAmt = 0
	
	this.SetItem(this.GetRow(),"amt2", dAmt * iBuho)
end if
if this.GetColumnName() = 'amt3' then
	dAmt = Double(this.GetText())
	if IsNull(dAmt) then dAmt = 0
	
	this.SetItem(this.GetRow(),"amt3", dAmt * iBuho)
end if

if this.GetColumnName() = 'amt4' then
	dAmt = Double(this.GetText())
	if IsNull(dAmt) then dAmt = 0
	
	this.SetItem(this.GetRow(),"amt4", dAmt * iBuho)
end if

if this.GetColumnName() = 'amt5' then
	dAmt = Double(this.GetText())
	if IsNull(dAmt) then dAmt = 0
	
	this.SetItem(this.GetRow(),"amt5", dAmt * iBuho)
end if
Wf_Calc_Auto()
return 2
end event

type p_update from p_retrieve within w_kgle55
integer x = 4270
integer taborder = 30
boolean bringtotop = true
string picturename = "C:\erpman\image\저장_up.gif"
end type

event ue_lbuttondown;PictureName = 'C:\erpman\image\저장_dn.gif'
end event

event ue_lbuttonup;PictureName = 'C:\erpman\image\저장_up.gif'
end event

event clicked;
dw_list.AcceptText()

IF f_dbConFirm('저장') = 2 THEN RETURN
	
IF dw_list.Update() = 1 THEN	
	commit;
	w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
	Return
END IF

end event

type rr_1 from roundrectangle within w_kgle55
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 188
integer width = 4544
integer height = 2036
integer cornerheight = 40
integer cornerwidth = 55
end type

