$PBExportHeader$w_pdt_06500.srw
$PBExportComments$** 설비이력카드
forward
global type w_pdt_06500 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_06500
end type
end forward

global type w_pdt_06500 from w_standard_print
string title = "설비관리대장"
rr_1 rr_1
end type
global w_pdt_06500 w_pdt_06500

forward prototypes
public function integer wf_retrieve ()
public subroutine wf_image (string as_mch)
end prototypes

public function integer wf_retrieve ();string mchno1, mchno2, gubun

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

mchno1 = trim(dw_ip.object.mchno1[1])
mchno2 = trim(dw_ip.object.mchno2[1])
gubun = trim(dw_ip.object.gubun[1])

//if (IsNull(mchno1) or mchno1 = "") then mchno1 = "."
//if (IsNull(mchno2) or mchno2 = "") then mchno2 = "ZZZZZZ"
if (IsNull(mchno1) or mchno1 = "") then 
	f_message_chk(50,"[설비 이력 카드-[기본정보]]")
	dw_ip.Setfocus()
	return -1
end if
mchno2 = mchno1
dw_list.SetFilter("") //구분 => ALL
dw_list.Filter( )

if gubun = "2" then //구분 => 보유
   dw_list.SetFilter("IsNull(pedat) or pedat = ''")
	dw_list.Filter( )
elseif gubun = "3" then //구분 => 폐기
	dw_list.SetFilter("not (IsNull(pedat) or pedat = '')")
	dw_list.Filter( )
end if	

dw_print.ShareDataoff()

if dw_print.Retrieve(gs_sabu, mchno1, mchno2) <= 0 then
	f_message_chk(50,"[설비 이력 카드-[기본정보]]")
	dw_ip.Setfocus()
	return -1
end if

//wf_image(mchno1)

return 1
end function

public subroutine wf_image (string as_mch);Blob    imagedata

SELECTBLOB IMAGE
      INTO :imagedata
      FROM LW_MCHMES_IMAGE
     WHERE SABU  = :gs_sabu
	    AND MCHGB = '1'
		 AND MCHNO = :as_mch ;

If SQLCA.SQLCODE = 0 Then

	Integer fp
	Integer loops
	Integer li_complete
	Long    new_pos
	Long    flen
	Long    bytes_read
	Long    j
	String  ls_fullname
	Decimal ld_total_size
	Blob    blob_chunk
		
	ls_fullname = 'C:\PIC\' + as_mch + '.jpg'
	fp = FileOpen(Trim(ls_fullname), StreamMode!, Write!, LockWrite!, replace!)

	new_pos = 1
	loops   = 0
	flen    = 0

	IF fp <> -1 then
		
		flen = len(imagedata)
		ld_total_size = ld_total_size + flen
		
		If flen > 32765 then
			If mod(flen,32765) = 0 then
				loops = flen / 32765
			Else
				loops = (flen / 32765) + 1
			End If
		Else
			loops = 1
		End If

		If loops = 1 then 
			bytes_read = FileWrite(fp, imagedata)
			Yield()
		Else
			For j = 1 To loops
				If j = loops then
					blob_chunk = BlobMid(imagedata, new_pos)
				Else
					blob_chunk = BlobMid(imagedata, new_pos, 32765)
				End If
				bytes_read = FileWrite(fp, blob_chunk)
				new_pos = new_pos + bytes_read

				Yield()
				li_complete = ( (32765 * j ) / len(imagedata)) * 100
			next
				Yield()
		End if
		
		FileClose(fp)
//		SetProfileString(gs_env_file, 'PROGRAM', ls_sfile, ls_sver)
	END IF
END IF
end subroutine

on w_pdt_06500.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_06500.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_xls from w_standard_print`p_xls within w_pdt_06500
end type

type p_sort from w_standard_print`p_sort within w_pdt_06500
end type

type p_preview from w_standard_print`p_preview within w_pdt_06500
end type

type p_exit from w_standard_print`p_exit within w_pdt_06500
end type

type p_print from w_standard_print`p_print within w_pdt_06500
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_06500
end type







type st_10 from w_standard_print`st_10 within w_pdt_06500
end type



type dw_print from w_standard_print`dw_print within w_pdt_06500
boolean visible = true
integer x = 46
integer y = 284
integer width = 4567
integer height = 1960
string dataobject = "d_pdt_06500_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_06500
integer x = 37
integer y = 44
integer width = 2473
integer height = 224
string dataobject = "d_pdt_06500_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String  s_cod, s_nam1

s_cod = Trim(this.getText())

if this.GetColumnName() = "mchno1" then 
	if IsNull(s_cod) or s_cod = "" then 
		this.object.mchnam1[1] = ""
		return 
	end if
	
	select mchnam into :s_nam1 from mchmst
	 where sabu = :gs_sabu and mchno = :s_cod;
	 
	if sqlca.sqlcode <> 0 then 
	   this.object.mchno1[1] = ""
	   this.object.mchnam1[1] = ""
	else
	   this.object.mchno1[1] = s_cod
	   this.object.mchnam1[1] = s_nam1
   end if
	
	wf_image(s_cod)
elseif this.GetColumnName() = "mchno2" then 
	if IsNull(s_cod) or s_cod = "" then 
		this.object.mchnam2[1] = ""
		return 
	end if
	
	select mchnam into :s_nam1 from mchmst
	 where sabu = :gs_sabu and mchno = :s_cod;
	 
	if sqlca.sqlcode <> 0 then 
	   this.object.mchno2[1] = ""
	   this.object.mchnam2[1] = ""
	else
	   this.object.mchno2[1] = s_cod
	   this.object.mchnam2[1] = s_nam1
   end if
end if

return
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.GetColumnName() = "mchno1" then
	gs_gubun = 'ALL'
	open(w_mchno_popup)
	if gs_code = '' or isnull(gs_code) then return 
	
	this.object.mchno1[1] = gs_code
	this.object.mchnam1[1] = gs_codename
	
	wf_image(gs_code)
	
elseif this.GetColumnName() = "mchno2" then
	gs_gubun = 'ALL'
   open(w_mchno_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.mchno2[1] = gs_code
	this.object.mchnam2[1] = gs_codename
end if	
end event

type dw_list from w_standard_print`dw_list within w_pdt_06500
boolean visible = false
integer x = 2565
integer y = 16
integer width = 357
integer height = 144
string dataobject = "d_pdt_06500_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdt_06500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 276
integer width = 4590
integer height = 1980
integer cornerheight = 40
integer cornerwidth = 55
end type

