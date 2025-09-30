$PBExportHeader$w_pdt_06550.srw
$PBExportComments$**설비점검기록표
forward
global type w_pdt_06550 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_06550
end type
end forward

global type w_pdt_06550 from w_standard_print
string title = "일상 점검기록표"
rr_1 rr_1
end type
global w_pdt_06550 w_pdt_06550

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ym, mchno1, mchno2, sGubun, sdept, inspbody1,inspbody2 
Long   i, j, k

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ym = trim(dw_ip.object.ym[1])
mchno1 = trim(dw_ip.object.mchno1[1])
mchno2 = trim(dw_ip.object.mchno2[1])
sgubun = dw_ip.object.gubun[1]
sdept  = trim(dw_ip.object.deptno[1])

if (IsNull(ym) or ym = "") then 
	f_message_chk(1400,"[기준년월]")
	dw_ip.SetColumn("ym")
	dw_ip.Setfocus()
	return -1
end if	
if IsNull(mchno1) or mchno1 = "" then mchno1 = "."
if IsNull(mchno2) or mchno2 = "" then mchno2 = "ZZZZZZ"
if IsNull(sdept) or sdept = "" then sdept = "%"

dw_list.dataobject = 'd_pdt_06550_02'
dw_list.Settransobject(sqlca)
dw_print.dataobject = 'd_pdt_06550_02_p'
dw_print.Settransobject(sqlca)

//dw_list.object.datawindow.print.preview = "yes"
//dw_print.object.datawindow.print.preview = "yes"
//
if sgubun = '1' then 
	dw_list.object.head_t.text = '설비 점검 체크시트'
	dw_print.object.head_t.text = '설비 점검 체크시트'
elseif sgubun = '2' then 
	dw_print.object.head_t.text = '설비 점검 체크시트'
	dw_list.object.head_t.text = '설비 점검 체크시트'
//else
//	dw_print.object.head_t.text = '주 유  점 검  기 록 표'
//	dw_list.object.head_t.text = '주 유  점 검  기 록 표'
end if
	
dw_list.object.txt_ym.text  = String(ym,"@@@@년 @@월")
dw_print.object.txt_ym.text = String(ym,"@@@@년 @@월")

if dw_list.Retrieve(gs_sabu, mchno1, mchno2, sgubun, sdept) <= 0 then
	f_message_chk(50,"[설비 점검 기록표]")
	dw_ip.Setfocus()
	return -1
end if

dw_list.sharedata(dw_print)

SetPointer(HourGlass!)
dw_list.setredraw(false)
dw_print.setredraw(false)
mchno1   = dw_print.object.mchno[1]
j = 0

for i = 1 to dw_print.RowCount()
	 if IsNull(Trim(dw_print.object.mchno[i])) or Trim(dw_print.object.mchno[i]) = "" then
	    continue 
    else	
		 mchno2    = dw_print.object.mchno[i]	
	 end if	 
	 if mchno1 = mchno2 then 
		 j++
	 else 	
		 for k = 1 to 20 - j
			  dw_print.InsertRow(i)
           dw_print.setItem(i, "mchno", mchno1)
			  i++
		 next	
		 mchno1    = mchno2
		 inspbody1 = inspbody2
		 j = 1
	 end if	 
next	
for k = 1 to 20 - j
	 dw_print.InsertRow(0)
    dw_print.setItem(dw_print.RowCount(), "mchno", mchno1)
next	
dw_print.groupcalc()
dw_list.setredraw(true)
dw_print.setredraw(true)
//dw_list.sharedata(dw_print)
dw_list.object.datawindow.print.preview = "yes"
dw_print.object.datawindow.print.preview = "yes"

setpointer(Arrow!)
return 1

end function

on w_pdt_06550.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_06550.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;sle_msg.Text = "조회버튼을 CLICK한 다음 출력버튼이 활성화 될 때까지 기다리세요!" 
end event

type p_preview from w_standard_print`p_preview within w_pdt_06550
end type

type p_exit from w_standard_print`p_exit within w_pdt_06550
end type

type p_print from w_standard_print`p_print within w_pdt_06550
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_06550
end type







type st_10 from w_standard_print`st_10 within w_pdt_06550
end type



type dw_print from w_standard_print`dw_print within w_pdt_06550
string dataobject = "d_pdt_06550_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_06550
integer x = 32
integer y = 36
integer width = 2693
integer height = 360
string dataobject = "d_pdt_06550_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  s_cod, s_nam, s_nam2
Int     i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "ym" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35,"[기준년월]")
		this.object.ym[1] = ""
		return 1
	end if	
elseif this.getcolumnname() = 'deptno' then 
	i_rtn = f_get_name2("부서", "Y", s_cod, s_nam, s_nam2)
	this.object.deptno[1] = s_cod
	this.object.deptnm[1] = s_nam
	return i_rtn
elseif this.GetColumnName() = "mchno1" then 
	if IsNull(s_cod) or s_cod = "" then 
		this.object.mchnm1[1] = ""
		return 
	end if
	
	select mchnam,buncd into :s_nam,:s_nam2 from mchmst
	 where sabu = :gs_sabu and mchno = :s_cod;
	 
	if sqlca.sqlcode <> 0 then 
	   this.object.mchno1[1] = ""
	   this.object.mchnm1[1] = ""
	   this.object.buncd1[1] = ""
	else
	   this.object.mchno1[1] = s_cod
	   this.object.mchnm1[1] = s_nam
	   this.object.buncd1[1] = s_nam2
   end if
elseif this.GetColumnName() = "mchno2" then 
	if IsNull(s_cod) or s_cod = "" then 
	   this.object.mchnm2[1] = ""
		return 
	end if
	
	select mchnam,buncd into :s_nam,:s_nam2 from mchmst
	 where sabu = :gs_sabu and mchno = :s_cod;
	 
	if sqlca.sqlcode <> 0 then 
	   this.object.mchno2[1] = ""
	   this.object.mchnm2[1] = ""
	   this.object.buncd2[1] = ""
	else
	   this.object.mchno2[1] = s_cod
	   this.object.mchnm2[1] = s_nam
	   this.object.buncd2[1] = s_nam2
   end if
elseif this.GetColumnName() = "buncd1" then 
	if IsNull(s_cod) or s_cod = "" then 
	   this.object.mchnm1[1] = ""
		return 
	end if
	
	select mchnam,mchno into :s_nam,:s_nam2 from mchmst
	 where sabu = :gs_sabu and buncd = :s_cod and rownum < 2;
	 
	if sqlca.sqlcode <> 0 then 
	   this.object.mchno1[1] = ""
	   this.object.mchnm1[1] = ""
	   this.object.buncd1[1] = ""
	else
	   this.object.mchno1[1] = s_nam2
	   this.object.mchnm1[1] = s_nam
	   this.object.buncd1[1] = s_cod
   end if
elseif this.GetColumnName() = "buncd2" then 
	if IsNull(s_cod) or s_cod = "" then 
	   this.object.mchnm2[1] = ""
		return 
	end if
	
	select mchnam,mchno into :s_nam,:s_nam2 from mchmst
	 where sabu = :gs_sabu and buncd = :s_cod and rownum < 2;
	 
	if sqlca.sqlcode <> 0 then 
	   this.object.mchno2[1] = ""
	   this.object.mchnm2[1] = ""
	   this.object.buncd2[1] = ""
	else
	   this.object.mchno2[1] = s_nam2
	   this.object.mchnm2[1] = s_nam
	   this.object.buncd2[1] = s_cod
   end if
end if


end event

event dw_ip::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "mchno1" THEN	
	gs_gubun = 'ALL'
	open(w_mchno_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "mchno1", gs_code)
	this.SetItem(1, "mchnm1", gs_codename)
ELSEIF this.getcolumnname() = "mchno2" THEN		
	gs_gubun = 'ALL'
	open(w_mchno_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "mchno2", gs_code)
	this.SetItem(1, "mchnm2", gs_codename)
ELSEIF this.getcolumnname() = "deptno"	THEN 
	open(w_vndmst_4_popup)
	if gs_code = '' or isnull(gs_code) then return 
   this.SetItem(1, "deptno", gs_code)
	this.SetItem(1, "deptnm", gs_codename)
END IF

end event

type dw_list from w_standard_print`dw_list within w_pdt_06550
integer x = 46
integer y = 428
integer width = 4549
integer height = 1784
string dataobject = "d_pdt_06550_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdt_06550
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 412
integer width = 4585
integer height = 1856
integer cornerheight = 40
integer cornerwidth = 55
end type

