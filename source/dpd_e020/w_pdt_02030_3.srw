$PBExportHeader$w_pdt_02030_3.srw
$PBExportComments$작업지시시 공정편집 화면
forward
global type w_pdt_02030_3 from window
end type
type p_4 from uo_picture within w_pdt_02030_3
end type
type p_3 from uo_picture within w_pdt_02030_3
end type
type dw_1 from datawindow within w_pdt_02030_3
end type
type rr_1 from roundrectangle within w_pdt_02030_3
end type
end forward

global type w_pdt_02030_3 from window
integer x = 142
integer y = 868
integer width = 3419
integer height = 1464
boolean titlebar = true
string title = "공정편집"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_4 p_4
p_3 p_3
dw_1 dw_1
rr_1 rr_1
end type
global w_pdt_02030_3 w_pdt_02030_3

forward prototypes
public function integer wf_check (ref string scolumn)
end prototypes

public function integer wf_check (ref string scolumn);string   snull, sitnbr, sreff, sreff1, sitdsc, sispec, scvcod, sopseq, spordno, stoday, sopcode, stime
integer  ireturn
Decimal  {5} dunprc
long     lfind, lrow

sToday = f_today()

if dw_1.accepttext() = -1 then return -1

setnull(snull)

spordno = dw_1.getitemstring(1, "morout_copy_pordno")

/* 공정코드 */
sopcode = dw_1.getitemstring(1, "morout_copy_opseq")
if isnull(sopcode) or trim(sopcode) = '' then
	f_message_chk(30,'[공정코드]') 
	dw_1.setitem(1, "morout_copy_opseq", '')
	scolumn = "morout_copy_opseq"
	RETURN  -1
end if

/* 공정명 */
sopcode = dw_1.getitemstring(1, "morout_copy_opdsc")
if isnull(sopcode) or trim(sopcode) = '' then
	f_message_chk(30,'[공정명]') 
	dw_1.setitem(1, "morout_copy_opdsc", '')
	scolumn = "morout_copy_opdsc"
	RETURN  -1
end if

/* 작업코드 */
sopcode = dw_1.getitemstring(1, "morout_copy_roslt")
if isnull(sopcode) or trim(sopcode) = '' then
	f_message_chk(30,'[작업코드]') 
	dw_1.setitem(1, "morout_copy_roslt", '')
	scolumn = "morout_copy_roslt"
	RETURN  -1
end if

/* 검사구분 */
sopcode = dw_1.getitemstring(1, "morout_copy_qcgub")
if isnull(sopcode) or trim(sopcode) = '' then
	f_message_chk(30,'[검사구분]') 
	dw_1.setitem(1, "morout_copy_qcgub", '')
	scolumn = "morout_copy_qcgub"
	RETURN  -1
end if

/* 시간계산기준 */
sopcode = dw_1.getitemstring(1, "morout_copy_esgbn")
if isnull(sopcode) or trim(sopcode) = '' then
	f_message_chk(30,'[시간계산기준]') 
	dw_1.setitem(1, "morout_copy_esgbn", '')
	scolumn = "morout_copy_esgbn"
	RETURN  -1
end if

/* 생산시작일*/
sreff = dw_1.getitemstring(1, "morout_copy_fsdat")
dw_1.setitem(1, "morout_copy_esdat", sreff)	
dw_1.setitem(1, "morout_copy_system_str_date", sreff)
if isnull(sreff) or trim(sreff) = '' or f_datechk(sreff) = -1 then
	f_message_chk(35,'[생산시작일(1)]') 
	dw_1.setitem(1, "morout_copy_esdat", '')
	dw_1.setitem(1, "morout_copy_fsdat", '')
	dw_1.setitem(1, "morout_copy_system_str_date", '')	
	scolumn = "morout_copy_fsdat"
	RETURN  -1
end if

/* 생산종료일 */
sreff1 = dw_1.getitemstring(1, "morout_copy_fedat")	
dw_1.setitem(1, "morout_copy_eedat", sreff1)
dw_1.setitem(1, "morout_copy_system_end_date", sreff1)
if isnull(sreff1) or trim(sreff1) = '' or f_datechk(sreff1) = -1 then
	f_message_chk(35,'[생산종료일(2)]') 
	dw_1.setitem(1, "morout_copy_eedat", '')
	dw_1.setitem(1, "morout_copy_fedat", '')		
	dw_1.setitem(1, "morout_copy_system_end_date", '')
	scolumn = "morout_copy_fedat"			
	RETURN  -1			
end if

if sreff > sreff1 then
	f_message_chk(35,'[생산종료일(3)]') 
	dw_1.setitem(1, "morout_copy_eedat", '')
	dw_1.setitem(1, "morout_copy_fedat", '')
	scolumn = "morout_copy_fedat"
	RETURN  -1			
end if

stime = dw_1.getitemstring(1, "morout_copy_fstim")
if isnull(stime) or trim(stime) = '' then
	f_message_chk(30,'[시작시각]') 
	dw_1.setitem(1, "morout_copy_fstim", '')
	scolumn = "morout_copy_fstim"
	RETURN  -1
end if

stime = dw_1.getitemstring(1, "morout_copy_fetim")
if isnull(stime) or trim(stime) = '' then
	f_message_chk(30,'[시작시각]') 
	dw_1.setitem(1, "morout_copy_fetim", '')
	scolumn = "morout_copy_fetim"
	RETURN  -1
end if

/* 작업장 */
ireturn = 0
sreff = dw_1.getitemstring(1, "morout_copy_wkctr")
select a.wkctr, a.wcdsc, b.jocod, b.jonam
  into :sitnbr, :sreff, :sitdsc, :sispec
  from wrkctr a, jomast b
 where a.wkctr = :sreff and a.jocod = b.jocod (+);
if sqlca.sqlcode <> 0 then
	f_message_chk(90,'[작업장]')
	setnull(sreff)		
	setnull(sitnbr)
	setnull(sitdsc)
	setnull(sispec)
	ireturn = -1
end if
if not isnull(sreff)  and isnull(sitdsc) then
	f_message_chk(91,'[조]')
	setnull(sreff)
	setnull(sitnbr)
	setnull(sitdsc)
	setnull(sispec)
	ireturn = -1
end if
dw_1.setitem(1, "morout_copy_wkctr", sitnbr)
dw_1.setitem(1, "wrkctr_wcdsc", sreff)
dw_1.setitem(1, "morout_copy_jocod", sitdsc)
dw_1.setitem(1, "jomast_jonam", sispec)
if ireturn = -1 then
	scolumn = "morout_copy_wkctr"
	return -1
end if

/* 설비 */
ireturn = 0
sreff = dw_1.getitemstring(1, "morout_copy_mchcod")
if not isnull(sreff) then
	select mchnam
	  into :sreff1
	  from mchmst
	 where sabu = :gs_sabu and mchno = :sreff;
	if sqlca.sqlcode <> 0 then
		f_message_chk(92,'[설비]')
		setnull(sreff)
		setnull(sreff1)		
		ireturn = -1
	end if
	dw_1.setitem(1, "mchmst_mchnam", sreff1)
	if ireturn = -1 then
		scolumn = "morout_copy_mchcod"
		return -1
	end if
end if
/* 외주유무 */
sreff = dw_1.getitemstring(1, "morout_copy_purgc")
if sreff = 'Y' then
	Setnull(sCvcod)
	scvcod = dw_1.getitemstring(1, "morout_copy_wicvcod")
	sopseq = dw_1.getitemstring(1, "morout_copy_opseq")
	ireturn = f_get_name2('V1', 'Y', scvcod, sitdsc, sispec)    //1이면 실패, 0이 성공	
	if ireturn = 0 then
		sitnbr = dw_1.getitemstring(1, "morout_copy_itnbr")
		
		select unprc into :dunprc from danmst
			 where itnbr = :sitnbr and cvcod = :scvcod and opseq = :sopseq;
			 
		 if sqlca.sqlcode <> 0 then
			 f_message_chk(82,'[ ' + sitdsc + ' ]')
		 end if
	end if	
	dw_1.setitem(1, "morout_copy_wicvcod", scvcod)	
	dw_1.setitem(1, "vndmst_cvnas2",  sitdsc)
	if ireturn  = 1 then
		f_message_chk(30,'[외주거래처]')
		scolumn = "morout_copy_wicvcod"
		RETURN -1
	end if
	
//	if dw_1.getitemdecimal(1, "morout_copy_wiunprc") < 1 then
//		f_message_chk(80,'[외주단가]') 
//		scolumn = "morout_copy_wiunprc"
//		RETURN  -1	
//	end if	
	
end if

/* 작업예상시간 */
dunprc = dw_1.getitemdecimal(1, "morout_copy_estim")
if dunprc < 0 then
	f_message_chk(93,'[작업예상시간]') 
	scolumn = "morout_copy_estim"
	RETURN  -1
end if

if dw_1.update() = 1 then
Else
	Rollback;
	Messagebox("공정저장", "공정저장에 실패하였읍니다", stopsign!)
	return -1
end if

// 공정순서 및 전공정 및 후공정 정리(단 공정추가인 경우에만 입력),
if dw_1.getitemstring(1, "uptgbn") = 'N' then
	datastore ds
	ds = create datastore
	ds.dataobject = 'd_pdt_02030_4'
	ds.settransobject(sqlca)
	ds.retrieve(gs_sabu, spordno)
	

	// 현재 공정을 기준으로 정리
	if ds.rowcount() > 1 then
		For Lrow = 1 to ds.rowcount()
			
			 // 공정구분
			 if Lrow = 1 then
				 ds.setitem(Lrow, "morout_copy_lastc", '1')
			 Elseif Lrow = ds.rowcount() then
				 ds.setitem(Lrow, "morout_copy_lastc", '3')
			 Else
				 ds.setitem(Lrow, "morout_copy_lastc", '0')
			 End if
			
			 //도착후 공정 check
			 if Lrow = ds.rowcount() then
				 ds.setitem(Lrow, 		"morout_copy_de_opseq", snull)				
			 Else
				 ds.setitem(Lrow - 1, "morout_copy_de_opseq", ds.getitemstring(Lrow, "morout_copy_opseq"))
			 End if	
	
			 //도착전 공정 check
			 if Lrow = 1 then 
				 ds.setitem(Lrow, "morout_copy_pr_opseq", '0000')
			 Else
				 ds.setitem(Lrow, "morout_copy_pr_opseq", ds.getitemstring(Lrow - 1, "morout_copy_opseq"))
			 End if
		Next
	else
		ds.setitem(1, "morout_copy_lastc", '9')	
		ds.setitem(1, "morout_copy_pr_opseq", '0000')	
		ds.setitem(1, "morout_copy_de_opseq", snull)	
	end if
	
	if ds.update() = 1 then
	Else
		Rollback;
		Messagebox("공정저장", "공정저장에 실패하였읍니다", stopsign!)
		return -1
	end if
	
	destroy ds
end if
		
	
return 1
end function

on w_pdt_02030_3.create
this.p_4=create p_4
this.p_3=create p_3
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.p_4,&
this.p_3,&
this.dw_1,&
this.rr_1}
end on

on w_pdt_02030_3.destroy
destroy(this.p_4)
destroy(this.p_3)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;f_window_center_response(this)

datawindowchild ds_deopseq, ds_propseq
dw_1.GetChild("morout_copy_de_opseq", ds_deopseq)
ds_deopseq.settransobject(sqlca)
if ds_deopseq.retrieve(gs_sabu, gs_code) < 1 then
	ds_deopseq.insertrow(0)
end if

dw_1.GetChild("morout_copy_pr_opseq", ds_propseq)
ds_propseq.settransobject(sqlca)
ds_propseq.retrieve(gs_sabu, gs_code)	
if ds_propseq.retrieve(gs_sabu, gs_code) < 1 then
	ds_propseq.insertrow(0)
end if

dw_1.settransobject(sqlca)

String sitnbr, spspec, smaster_no, sitdsc, sispec
Dec    dpdqty

If Not isnull(gs_codename) then
	dw_1.retrieve(gs_sabu, gs_code, gs_codename)
	dw_1.setitem(1, "uptgbn", 'Y')
	dw_1.setcolumn("morout_copy_watims")
	dw_1.setfocus()
Else
	dw_1.insertrow(0)	
	
	// 작업지시의 기본적인 내역을 Move
	Select a.itnbr, a.pspec, a.master_no, a.pdqty , i.itdsc, i.ispec
	  into :sitnbr, :spspec, :smaster_no, :dpdqty, :sitdsc, :sispec
	  From Momast_copy a, itemas i
	 Where a.Sabu = :gs_sabu And a.Pordno = :gs_code
	   and a.itnbr = i.itnbr;
	 
	dw_1.setitem(1, "morout_copy_sabu", 		gs_sabu)
	dw_1.setitem(1, "morout_copy_pordno", 		gs_code)
	dw_1.setitem(1, "morout_copy_itnbr", 		sItnbr)
	dw_1.setitem(1, "itemas_itdsc",		 		sItdsc)
	dw_1.setitem(1, "itemas_ispec",		 		sispec)
	dw_1.setitem(1, "morout_copy_pspec", 		sPspec)
	dw_1.setitem(1, "morout_copy_pdqty", 		dpdqty)
	dw_1.setitem(1, "morout_copy_master_no",	smaster_no)	
	dw_1.setitem(1, "uptgbn", 'N')
	dw_1.setcolumn("morout_copy_opseq")
	dw_1.setfocus()	
End if
end event

type p_4 from uo_picture within w_pdt_02030_3
integer x = 3177
integer y = 24
integer width = 178
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;Closewithreturn(parent, 'N')
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\취소_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

type p_3 from uo_picture within w_pdt_02030_3
integer x = 2990
integer y = 24
integer width = 178
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;if dw_1.accepttext() = -1 then return

string scolumn

if wf_check(scolumn) = -1 then
	dw_1.setcolumn(scolumn)
	dw_1.setfocus()
	return
else
	Commit;
	Closewithreturn(parent, 'Y')	
end if


end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

type dw_1 from datawindow within w_pdt_02030_3
event ue_key pbm_dwnkey
event ue_processenter pbm_dwnprocessenter
integer x = 50
integer y = 204
integer width = 3282
integer height = 1152
integer taborder = 10
string dataobject = "d_pdt_02030_4a"
boolean border = false
boolean livescroll = true
end type

event ue_key;if key  = keyf1! then
	this.triggerevent(rbuttondown!)
end if
end event

event ue_processenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;string   snull, sitnbr, sreff, sreff1, sitdsc, sispec, scvcod, sopseq, stoday, sPordno, stropseq, srtnggu, &
			sIogbn, sDptno, sOpdsc, sPurgc, stuncu, scvnas, sroslt, spropseq, sdeopseq, stimegu, sqcgub, sbasic, swkctr, swcdsc
long     lrow,  lcnt
integer  ireturn
Decimal {5} dunprc, dstdst, dstdmc, dmanhr, dmchr, dpqty 
String   ls_pspec, stime

setnull(snull)

lrow   = 1

if accepttext() = -1 then
	Messagebox("자료확인", "자료확인시 오류 발생", stopsign!)
	return 1
end if

if  	 this.getcolumnname() = "morout_copy_opseq" then
		sopseq  = gettext()
		sitnbr  = getitemstring(1, "morout_copy_itnbr")
		spordno = getitemstring(1, "morout_copy_pordno")
		
		// 동일한 공정번호가 있는 지 검색
		Lcnt = 0
		Select count(*) into :lcnt from morout_copy
		 Where Sabu = :gs_sabu And pordno = :spordno And opseq = :sopseq;		
		if Lcnt > 0 then
			Messagebox("공정번호", "동일한 공정번호가 존재합니다", stopsign!)
			setitem(1, "morout_copy_opdsc", sopseq)
			setitem(1, "morout_copy_opdsc", snull) 
			setitem(1, "morout_copy_roslt", snull)	
			setitem(1, "morout_copy_de_opseq", snull) 
			setitem(1, "morout_copy_pr_opseq", snull)
			return 1
		end if
		
		// 지수수량 검색
		Select pdqty into :dpqty from momast_copy where sabu = :gs_sabu And pordno = :spordno;
		if isnull( dpqty ) then dpqty = 0
		
		/* 시간적용 구분을 환경설정에서 검색 (1:표준시간, 2:평균시간) */
		select dataname
		  into :stimegu
		  from syscnfg
		 where sysgu = 'Y' and serial = '15' and lineno = '3';
		 
		if isnull( stimegu ) or trim( stimegu ) = '' or ( stimegu <> '1' And stimegu <> '2' ) Then
			stimegu = '2'
		End if
		
		/* 보고유무 구분을 환경설정에서 검색 (1:보고공정만 생성, 2:전체생성)*/
		select dataname
		  into :srtnggu
		  from syscnfg
		 where sysgu = 'Y' and serial = '15' and lineno = '6';
	
		/* 보고유무를 사용할 경우에는 보고안하는 공정을 합산한다 */
		if srtnggu = '1' then
			select Max(decode(uptgu, 'Y', opseq, '')) into :stropseq
			  from routng
			 where itnbr = :sitnbr and opseq < :sopseq;
		else
			stropseq = sopseq
		End if;
		 
		if isnull( stropseq ) then stropseq = '0000' 
		
		setnull(sopdsc)
		setnull(sroslt)
		Select a.opdsc, a.roslt, a.qcgub, b.wkctr, b.wcdsc, b.basic, 
				 nvl(c.stdst, 0), nvl(c.stdmc, 0), nvl(c.manhr, 0), nvl(c.mchr, 0)		
		  into :sopdsc, :sroslt, :sqcgub, :swkctr, :swcdsc, :sbasic, :dstdst, :dstdmc, :dmanhr, :dmchr 
		  from routng a, wrkctr b,
		  		(select nvl(sum(a.stdst), 0) as stdst, nvl(sum(a.stdmc), 0)   as stdmc,
						  nvl(sum(decode(:stimegu, '1', a.manhr, a.manhr1)), 0) as manhr,
				 		  nvl(sum(decode(:stimegu, '1', a.mchr,  a.mchr1)), 0)  as mchr
				  	from routng a, wrkctr b
				  Where a.itnbr = :sitnbr And a.opseq > :stropseq And a.opseq <= :sopseq
		 			 and a.wkctr = b.wkctr) c
		 Where a.itnbr = :sitnbr And a.opseq = :sopseq
		 	and a.wkctr = b.wkctr;
			 
		if isnull( dstdst ) then dstdst = 0
		if isnull( dstdmc ) then dstdmc = 0
		if isnull( dmanhr ) then dmanhr = 0
		if isnull( dmchr  ) then dmchr  = 0
		
		dmanhr = dmanhr * dpqty;
		dmchr  = dmchr  * dpqty;
		 
		setitem(1, "morout_copy_opdsc", sopdsc) 
		setitem(1, "morout_copy_roslt", sroslt)
		setitem(1, "morout_copy_esinw", dstdmc)
		setitem(1, "morout_copy_estim", dstdst + dmanhr + dmchr)
		setitem(1, "morout_copy_esset", dstdst)
		setitem(1, "morout_copy_esman", dmanhr)
		setitem(1, "morout_copy_esmch", dmchr)		
		setitem(1, "morout_copy_esgbn", sBasic)
		setitem(1, "morout_copy_wkctr", swkctr)
		setitem(1, "wrkctr_wcdsc", swcdsc)		
		
		// 입력된 공정코드 이전의 제일작은 공정코드를 검색
		setnull(spropseq)
		Select Max(opseq) into :spropseq From morout_copy
		 Where Sabu = :gs_sabu And pordno = :spordno And opseq < :sopseq;
		 
		if isnull( spropseq ) then spropseq = '0000'
		
		// 입력된 공정코드 이전의 제일작은 공정코드를 검색
		setnull(sdeopseq)
		Select Min(opseq) into :sdeopseq From morout_copy
		 Where Sabu = :gs_sabu And pordno = :spordno And opseq > :sopseq;
		 
		setitem(1, "morout_copy_de_opseq", sdeopseq) 
		setitem(1, "morout_copy_pr_opseq", spropseq)	
	
Elseif this.getcolumnname() = "morout_copy_fsdat" then
	if isnull(this.gettext()) or trim(this.gettext()) = '' then
		f_message_chk(35,'[생산시작일]') 
		this.setitem(lrow, "morout_copy_esdat", '')
		this.setitem(lrow, "morout_copy_fsdat", '')
		RETURN  1
	end if
	if f_datechk(this.gettext()) = -1 then
		f_message_chk(35,'[생산시작일]') 
		this.setitem(lrow, "morout_copy_esdat", '')
		this.setitem(lrow, "morout_copy_fsdat", '')		
		RETURN  1			
	end if
	this.setitem(lrow, "morout_copy_esdat", this.gettext())
elseif this.getcolumnname() = "morout_copy_fedat" then
	if isnull(this.gettext()) or trim(this.gettext()) = '' then
		f_message_chk(35,'[생산종료일]') 
		this.setitem(lrow, "morout_copy_esdat", '')
		this.setitem(lrow, "morout_copy_eedat", '')
		this.setitem(lrow, "morout_copy_fsdat", '')
		this.setitem(lrow, "morout_copy_fedat", '')		
		RETURN  1			
	end if
	if f_datechk(this.gettext()) = -1 then
		f_message_chk(35,'[생산종료일]') 
		this.setitem(lrow, "morout_copy_esdat", '')
		this.setitem(lrow, "morout_copy_eedat", '')
		this.setitem(lrow, "morout_copy_fsdat", '')
		this.setitem(lrow, "morout_copy_fedat", '')		
		RETURN  1			
	end if
	if this.getitemstring(lrow, "morout_copy_fsdat") > this.gettext() then
		f_message_chk(35,'[생산종료일]') 
		this.setitem(lrow, "morout_copy_esdat", '')
		this.setitem(lrow, "morout_copy_eedat", '')
		this.setitem(lrow, "morout_copy_fsdat", '')
		this.setitem(lrow, "morout_copy_fedat", '')
		RETURN  1			
	end if
	this.setitem(lrow, "morout_copy_eedat", this.gettext())
// 작업시작시각
elseif getcolumnname() = "morout_copy_fstim" then
	sTime = trim(this.gettext())
	if f_timechk(sTime) <> 1 Then
		f_message_chk(30, "시각")
		return 1
	end if
// 작업시작시각
elseif getcolumnname() = "morout_copy_fetim" then
	sTime = trim(this.gettext())
	if f_timechk(sTime) <> 1 Then
		f_message_chk(30, "시각")
		return 1
	end if
elseif this.getcolumnname() = "morout_copy_wkctr" then
	ireturn = 0
	sreff = this.gettext()
	select a.wkctr, a.wcdsc, b.jocod, b.jonam
	  into :sitnbr, :sreff1, :sitdsc, :sispec
	  from wrkctr a, jomast b
	 where a.wkctr = :sreff and a.jocod = b.jocod (+);
	if sqlca.sqlcode <> 0 then
		f_message_chk(90,'[작업장]')
		setnull(sreff1)		
		setnull(sitnbr)
		setnull(sitdsc)
		setnull(sispec)
		ireturn = 1
	end if
	if not isnull(sreff1)  and isnull(sitdsc) then
		f_message_chk(91,'[조]')
		setnull(sreff1)
		setnull(sitnbr)
		setnull(sitdsc)
		setnull(sispec)
		ireturn = 1
	end if
	this.setitem(lrow, "morout_copy_wkctr", sitnbr)
	this.setitem(lrow, "wrkctr_wcdsc", sreff1)
	this.setitem(lrow, "morout_copy_jocod", sitdsc)
	this.setitem(lrow, "jomast_jonam", sispec)
	return ireturn
elseif this.getcolumnname() = "morout_copy_mchcod" then
	ireturn = 0
	sreff = this.getitemstring(lrow, "morout_copy_mchcod")
	select mchnam
	  into :sreff1
	  from mchmst
	 where sabu = :gs_sabu and mchno = :sreff;
	if sqlca.sqlcode <> 0 then
		f_message_chk(92,'[설비]')
		setnull(sreff)
		setnull(sreff1)
		ireturn = 1
	end if
	this.setitem(lrow, "mchmst_mchnam", sreff1)
	return ireturn	
elseif this.getcolumnname() = "morout_copy_purgc"  then	
	this.setitem(lrow, "morout_copy_wicvcod", '')
	this.setitem(lrow, "vndmst_cvnas2", '')
	this.setitem(lrow, "morout_copy_wiunprc", 0)
	
	sPordno = getitemstring(lrow, "morout_copy_pordno")
	sItnbr  = getitemstring(lrow, "morout_copy_itnbr")	
	sopseq  = getitemstring(lrow, "morout_copy_opseq")	
	sopdsc  = getitemstring(lrow, "morout_copy_opdsc")	
	sPurgc  = this.gettext()
	
	if sPurgc = 'N' then
		// 외주가 아닌 경우에는 자재 출고 구분을 자동출고 구분을 Setting한다.
		Select Iogbn Into :sIogbn from iomatrix where sabu = '1' and autpdt = 'Y';
		if sqlca.sqlcode <> 0 then
			Messagebox("생산출고", "자동출고용 수불구분을 검색할 수 없읍니다", stopsign!)
			return 1
		end if
		
		select pdtgu into :sdptno from momast_copy
		 where sabu = :gs_sabu and pordno = :spordno;

		// 2001/05/11 유 추가 ==> 소진창고 최우선순위 추가 
		select depot_no 
		  into :sCvcod
		  from routng
		 where itnbr = :sItnbr and opseq = :sopseq ;			
	
		if isnull(sCvcod) or sCvcod = '' then 
			select cvcod   into :sCvcod
			  from vndmst where cvgu = '5' and jumaeip = :sDptno and rownum = 1;
		end if
			
		Update Holdstock_copy
			Set out_store = :sCvcod,
				 Hold_gu	  = :sIogbn, 
				 out_chk	  = '1',
				 naougu	  = '1' 				 
		 Where sabu = :gs_sabu and Pordno = :sPordno and opseq = :sOpseq;
			
		Commit;	
		
	Else
			
		sitnbr 		= getitemstring(1, "morout_copy_itnbr")
		ls_pspec 	= getitemstring(1, "morout_copy_pspec")
		
		f_buy_unprc(sitnbr, ls_pspec, sopseq, scvcod, scvnas, dUnprc, sTuncu)				
		
		select cvcod, unprc into :sCvcod, :dUnprc from danmst
			 where itnbr = :sitnbr and opseq = :sopseq and sltcd = 'Y';
			 
		 if sqlca.sqlcode <> 0 then
	 		 f_message_chk(82,'[ ' + sOpdsc + ' ]')
		 end if
		 
		setitem(Lrow, "morout_copy_wicvcod", sCvcod)
		setitem(lrow, "morout_copy_wiunprc", dunprc)
		ireturn = f_get_name2('V1', 'Y', scvcod, sitdsc, sispec)    //1이면 실패, 0이 성공
		setitem(Lrow, "vndmst_cvnas2", sItdsc)		 
		
		// 외주인 경우에는 자재 출고 구분을 외주출고 구분을 Setting한다.
		Select Iogbn Into :sIogbn from iomatrix where sabu = '1' and autvnd = 'Y';
		if sqlca.sqlcode <> 0 then
			Messagebox("사급출고", "사급출고용 수불구분을 검색할 수 없읍니다", stopsign!)
			return 1
		end if
		Update Holdstock_copy
			Set out_store = :sCvcod,
				 Hold_gu	  = :sIogbn, 
				 out_chk	  = '2',
				 naougu	  = '2' 
		 Where sabu = :gs_sabu and Pordno = :sPordno and opseq = :sOpseq;
		Commit;		
		
	end if	
	
elseif this.getcolumnname() = "morout_copy_wicvcod"	then
	scvcod = this.getitemstring(lrow, "morout_copy_wicvcod")
	sopseq = this.getitemstring(lrow, "morout_copy_opseq")
	ireturn = f_get_name2('V1', 'Y', scvcod, sitdsc, sispec)    //1이면 실패, 0이 성공	
	if ireturn = 0 then
		sitnbr = getitemstring(1, "morout_copy_itnbr")
		select unprc into :dunprc from danmst
			 where itnbr = :sitnbr and cvcod = :scvcod and opseq = :sopseq and sltcd = 'Y';
		 if sqlca.sqlcode <> 0 then
	 		 f_message_chk(82,'[ ' + sitdsc + ' ]')
			 scvcod = ''
			 dunprc = 0
			 sitnbr = ''
			 sitdsc = ''
			 ireturn = 1
		 else
			 this.setitem(lrow, "morout_copy_wiunprc", dunprc)
		 end if
	end if	
	
	sPordno = getitemstring(Lrow, "morout_copy_pordno")
	sopseq  = getitemstring(lrow, "morout_copy_opseq")		
	
	// 할당의 소진처를 변경
	Update Holdstock_copy
		Set out_store = sCvcod
	 Where sabu = :gs_sabu and Pordno = :sPordno;
	Commit;			
	
	this.setitem(lrow, "morout_copy_wicvcod", scvcod)	
	this.setitem(lrow, "vndmst_cvnas2",  sitdsc)
   this.setitem(lrow, "morout_copy_wiunprc", dunprc)
	RETURN ireturn
elseif this.getcolumnname() = "morout_copy_wiunprc"  then
	if dec(this.gettext()) < 1 then
		f_message_chk(80,'[외주단가]') 
		RETURN  1	
	end if	
elseif this.getcolumnname() = "morout_copy_esset"  then
	setitem(1, "morout_copy_estim", getitemdecimal(1, "morout_copy_esman") + getitemdecimal(1, "morout_copy_esmch") + dec(gettext()))
elseif this.getcolumnname() = "morout_copy_esman"  then
	setitem(1, "morout_copy_estim", getitemdecimal(1, "morout_copy_esset") + getitemdecimal(1, "morout_copy_esmch") + dec(gettext()))	
elseif this.getcolumnname() = "morout_copy_esmch"  then
	setitem(1, "morout_copy_estim", getitemdecimal(1, "morout_copy_esset") + getitemdecimal(1, "morout_copy_esman") + dec(gettext()))		
end if
end event

event itemerror;return 1
end event

event rbuttondown;string colname
long   lrow

SETNULL(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

colname = this.getcolumnname()
lrow    = this.getrow()

if     colname = "morout_copy_mchcod" then
		 gs_code = this.gettext()
		 gs_gubun    = this.getitemstring(lrow, "morout_copy_wkctr")
		 gs_codename = this.getitemstring(lrow, "wrkctr_wcdsc")
		 open(w_mchmst_popup)
	  	 IF gs_code = '' or isnull(gs_code) then return 
		 this.setitem(lrow, "morout_copy_mchcod", gs_code)
		 this.triggerevent(itemchanged!)
elseif colname = "morout_copy_wicvcod" then
		 gs_code = getitemstring(lrow, "morout_copy_itnbr")
		 gs_codename = this.getitemstring(lrow, "morout_copy_opseq")
		 open(w_danmst_popup)
	  	 IF gs_code = '' or isnull(gs_code) then return 
		 this.setitem(lrow, "morout_copy_wicvcod", gs_code)
		 this.triggerevent(itemchanged!)
elseif colname = "morout_copy_wkctr" then
		 gs_code = this.gettext()
		 open(w_workplace_popup)
	  	 IF gs_code = '' or isnull(gs_code) then return 
		 this.setitem(lrow, "morout_copy_wkctr", gs_code)
		 this.triggerevent(itemchanged!)
end if


end event

type rr_1 from roundrectangle within w_pdt_02030_3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 196
integer width = 3346
integer height = 1176
integer cornerheight = 40
integer cornerwidth = 55
end type

