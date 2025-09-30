$PBExportHeader$w_kfia54.srw
$PBExportComments$차입금 상환계획표 조회 및 출력
forward
global type w_kfia54 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfia54
end type
end forward

global type w_kfia54 from w_standard_print
integer x = 0
integer y = 0
string title = "차입금 상환계획표 조회출력"
rr_1 rr_1
end type
global w_kfia54 w_kfia54

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_lo_cdf, ls_lo_cdt, get_namef,  get_namet, &
       get_codef, get_codet, snull
long ll_row

SetNull(snull)

ll_row = dw_ip.GetRow()

if ll_row < 1 then return -1 

if dw_ip.AcceptText() = -1 then return -1

ls_lo_cdf = dw_ip.GetItemString(ll_row, 'lo_cdf')
ls_lo_cdt = dw_ip.GetItemString(ll_row, 'lo_cdt')

if trim(ls_lo_cdf) = '' or isnull(ls_lo_cdf) then 
	
    SELECT MIN("KFM03OT0"."LO_CD") AS LO_CDF
	 INTO :get_codef
	 FROM "KFM03OT0"  ;

	 if sqlca.sqlcode <> 0 then 
		MessageBox("확 인", "차입금 코드를 확인하십시오.!!")
		dw_ip.SetColumn('lo_cdf')
		dw_ip.SetFocus()
		return -1
    end if
	 
	ls_lo_cdf = get_codef
	
else
	 SELECT "KFM03OT0"."LO_NAME"  
	 INTO :get_namef
	 FROM "KFM03OT0"  
	 WHERE "KFM03OT0"."LO_CD" = :ls_lo_cdf;
	 
	 if sqlca.sqlcode = 0 then 
		dw_ip.SetItem(ll_row, 'lo_namef', get_namef)
	 else
		MessageBox("확 인", "차입금 코드를 확인하십시오.!!")
		dw_ip.SetItem(ll_row, 'lo_cdf', snull)						
		dw_ip.SetItem(ll_row, 'lo_namef', snull)			
		dw_ip.SetColumn('lo_cdf')
		dw_ip.SetFocus()
		return -1
	 end if
end if

if trim(ls_lo_cdt) = '' or isnull(ls_lo_cdt) then 
    SELECT MAX("KFM03OT0"."LO_CD") AS LO_CDT
	 INTO :get_codet
	 FROM "KFM03OT0"  ;

	 if sqlca.sqlcode <> 0 then 
		MessageBox("확 인", "차입금 코드를 확인하십시오.!!")
		dw_ip.SetColumn('lo_cdt')
		dw_ip.SetFocus()
		return -1
    end if
	 
	ls_lo_cdt = get_codet

else
	 SELECT "KFM03OT0"."LO_NAME"  
	 INTO :get_namet
	 FROM "KFM03OT0"  
	 WHERE "KFM03OT0"."LO_CD" = :ls_lo_cdt;
	 if sqlca.sqlcode = 0 then 
		dw_ip.SetItem(ll_row, 'lo_namet', get_namet)
		
	 else
		
		MessageBox("확 인", "차입금 코드를 확인하십시오.!!")
		dw_ip.SetItem(ll_row, 'lo_cdt', snull)						
		dw_ip.SetItem(ll_row, 'lo_namet', snull)			
		dw_ip.SetColumn('lo_cdt')
		dw_ip.SetFocus()
		return 1
	 end if
end if

dw_list.SetRedraw(false)

if dw_print.retrieve(ls_lo_cdf, ls_lo_cdt) < 1 then
	F_MessageChk(14, "")

	dw_list.reset()
	dw_list.insertrow(0)
   dw_list.SetRedraw(true)		
	dw_ip.SetColumn('lo_cdf')
	dw_ip.SetFocus()
   //return -1
end if
dw_print.sharedata(dw_list)
dw_list.SetRedraw(true)		

return 1
end function

on w_kfia54.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfia54.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.Setcolumn('lo_cdf')
dw_ip.Setfocus()

end event

type p_preview from w_standard_print`p_preview within w_kfia54
end type

type p_exit from w_standard_print`p_exit within w_kfia54
end type

type p_print from w_standard_print`p_print within w_kfia54
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfia54
end type







type st_10 from w_standard_print`st_10 within w_kfia54
end type



type dw_print from w_standard_print`dw_print within w_kfia54
string dataobject = "dw_kfia54_02_P"
end type

type dw_ip from w_standard_print`dw_ip within w_kfia54
integer y = 20
integer width = 2021
integer height = 196
string dataobject = "dw_kfia54_01"
end type

event dw_ip::itemchanged;string ls_lo_cdf, ls_lo_cdt, get_name, snull

SetNull(snull)

// 차입금 코드 from
if this.GetColumnName() = 'lo_cdf' then
	ls_lo_cdf = this.GetText()
	if trim(ls_lo_cdf) = '' or isnull(ls_lo_cdf) then 
		this.SetItem(this.GetRow(), 'lo_namef', snull)
	   return 
	else
		 SELECT "KFM03OT0"."LO_NAME"  
		 INTO :get_name
		 FROM "KFM03OT0"  
		 WHERE "KFM03OT0"."LO_CD" = :ls_lo_cdf;
       if sqlca.sqlcode = 0 then 
			this.SetItem(this.GetRow(), 'lo_namef', get_name)
		 else
//			MessageBox("확 인", "차입금 코드를 확인하십시오.!!")
//			this.SetItem(this.GetRow(), 'lo_cdf', snull)						
//			this.SetItem(this.GetRow(), 'lo_namef', snull)			
//			return 1
       end if
	end if
	
// 차입금 코드 to
elseif this.GetColumnName() = 'lo_cdt' then
	ls_lo_cdt = this.GetText()
	if trim(ls_lo_cdt) = '' or isnull(ls_lo_cdt) then 
		this.SetItem(this.GetRow(), 'lo_namet', snull)
	   return 
	else
		 SELECT "KFM03OT0"."LO_NAME"  
		 INTO :get_name
		 FROM "KFM03OT0"  
		 WHERE "KFM03OT0"."LO_CD" = :ls_lo_cdt;
       if sqlca.sqlcode = 0 then 
			this.SetItem(this.GetRow(), 'lo_namet', get_name)
		 else
//			MessageBox("확 인", "차입금 코드를 확인하십시오.!!")
//			this.SetItem(this.GetRow(), 'lo_cdt', snull)						
//			this.SetItem(this.GetRow(), 'lo_namet', snull)			
//			return 1
       end if
	end if
end if
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;String snull

SetNull(snull)
SetNull(gs_code)
SetNull(gs_codename)

this.accepttext()

// 차입금 코드 from
IF this.GetColumnName() ="lo_cdf" THEN
	gs_code =Trim(this.GetItemString(this.GetRow(),"lo_cdf"))
	IF IsNull(gs_code) THEN
		gs_code =""
	END IF
	OPEN(W_KFM03OT0_POPUP)
	IF Not IsNull(gs_code) THEN
		this.SetItem(this.GetRow(), 'lo_cdf', gs_code)
      this.SetItem(this.GetRow(), 'lo_namef', gs_codename)
	END IF
//	this.TriggerEvent(ItemChanged!)
	
// 차입금 코드 to
ELSEIF this.GetColumnName() ="lo_cdt" THEN
	gs_code =Trim(this.GetItemString(this.GetRow(),"lo_cdt"))
	IF IsNull(gs_code) THEN
		gs_code =""
	END IF
	OPEN(W_KFM03OT0_POPUP)
	IF Not IsNull(gs_code) THEN
		this.SetItem(this.GetRow(), 'lo_cdt', gs_code)
      this.SetItem(this.GetRow(), 'lo_namet', gs_codename)
	END IF
//	this.TriggerEvent(ItemChanged!)
end if
end event

event dw_ip::getfocus;this.AcceptText()
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kfia54
integer x = 64
integer y = 224
integer width = 4512
integer height = 1980
string title = "차입금 상환계획표"
string dataobject = "dw_kfia54_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfia54
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 220
integer width = 4544
integer height = 2004
integer cornerheight = 40
integer cornerwidth = 55
end type

