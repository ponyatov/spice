-- ��� lua ������ ��� FEMM 4.0
--------------------------------------------------------------------------------
---- ������ 2.4.04 �� 22 ������ 2006 �. 
--------------------------------------------------------------------------------
-- ������ �� ����� ��������� ���������
--------------------------------------------------------------------------------
File_name=prompt ("������� ��� ����� � ������� �����, ��� ���������� .txt") 

handle = openfile(File_name .. ".txt","r")
pustaja_stroka = read(handle, "*l") -- ������ ���������� ������ 4 ��
pustaja_stroka = read(handle, "*l")
pustaja_stroka = read(handle, "*l")
pustaja_stroka = read(handle, "*l")

C = read(handle, "*n", "*l") 	-- ������� ������������, ����������		
U = read(handle, "*n", "*l")	-- ���������� �� ������������, ����� 

Dpr = read(handle, "*n", "*l")	-- ������� ����������� ������� �������, ��������
Tiz = read(handle, "*n", "*l")	-- ��������� ������� �������� ������� (������� �������� � �������� � �������� ������), ��
Lkat = read(handle, "*n", "*l")	-- ����� ������� (�� �������� ������ �������� �����. ������� �������), ��������				
Dkat = read(handle, "*n", "*l")	-- ������� ������� �������, ��������
Lmag = read(handle, "*n", "*l")	-- ������� �������� ��������������, �� ����� ��������� �������, ���� ���� �� ��� ���, ��������
Nom_mat_magnitoprovoda = read(handle, "*n", "*l")	-- �������� �� �������� ������ ������������� ������� ��. �������

Nom_mat_puli = read(handle, "*n", "*l")	-- �������� �� �������� ������� ���� ��. �������
Lpuli  = read(handle, "*n", "*l")	-- ����� ����, ��������		
Dpuli = read(handle, "*n", "*l")	-- ������� ����, ��������
Lsdv = read(handle, "*n", "*l")		-- ����������, �� ������� � ��������� ������ �������� ���� � ������� ��� ��������� �� ������� � �������, ��������

Dstvola = read(handle, "*n", "*l")	-- ������� ������� ������ (�� �������� ������ �������� ����), ��������
Vel0 = read(handle, "*n", "*l")		-- ��������� �������� ����, �/� (������ 0 ����� �����-�� ��������� ��������, ����� ����� �� ����� �����)
delta_t = read(handle, "*n", "*l")	-- ���������� �������, ��� 

closefile(handle)
--------------------------------------------------------------------------------

kRC = 140      -- ���������� ��������� RC ��� ��������������� ������������������ �����������, ��*���
Rcc = (kRC/C)  -- ���������� ������������� ������������
Rv = 0.35+Rcc     -- ������������� ���������� �������� + ������������� ��������� + ���������� ������������� ������������, ��

Vol =4                -- ��������� ���������� ������������ ������ ������ (������������� �������� �� 3 �� 5)
Coil_meshsize = 0.5    -- ������ ����� �������, ��
Proj_meshsize = 0.35    -- ������ ����� ����, ��
max_segm      = 5     -- ������������ ������ �������� ������������, ����

t = 0			-- ��������� ������ �������, �������
sigma = 0.0000000175	-- �������� ������������� ����, �� * ����
ro = 7800		-- ��������� ������, ��/����^3
pi = 3.1415926535  
--------------------------------------------------------------------------------
-- ��������
--------------------------------------------------------------------------------
Start_date= date()


create(0)							-- ������� �������� ��� ��������� �����

mi_probdef(0,"millimeters","axi",1E-8,30)			-- ������� ������

mi_saveas("temp.fem")						-- ��������� ���� ��� ������ ������

mi_addmaterial("Air",1,1)					-- ��������� �������� ������

mi_addmaterial("Cu",1,1,"","","",58,"","","",4,"","",1,Dpr)	-- ��������� �������� ������ ������ ��������� Dpr ������������� 58

mi_addcircprop("katushka",0,0,1)				-- ��������� ������� 

dofile ("func.lua")	-- ����������� ������� ��� ����������� ������� � ���					
vvod_materiala (Nom_mat_magnitoprovoda,"M")	-- ������ �������� �������������� ������� ��� ��� � � ����� ���������
Material_magnitoprovoda="M" .. Nom_mat_magnitoprovoda

vvod_materiala (Nom_mat_puli,"P")		---- ������ �������� ���� ������� ��� ��� � � ����� ���������
Material_puli="P" .. Nom_mat_puli	

--------------------------------------------------------------------------------
-- ����������� �������
--------------------------------------------------------------------------------

--������� ������������ � Vol ��� ������� ��� �������
mi_addnode(0,(Lkat+Lmag)*-Vol) 				-- ������ �����
mi_addnode(0,(Lkat+Lmag)*Vol)				-- ������ �����
mi_addsegment(0,(Lkat+Lmag)*-Vol,0,(Lkat+Lmag)*Vol)		-- ������ �����
mi_addarc(0,(Lkat+Lmag)*-Vol,0,(Lkat+Lmag)*Vol,180,max_segm)	-- ������ ����

mi_addblocklabel((Lkat+Lmag)*0.7*Vol,0)				-- ��������� ����	
mi_clearselected()						-- �������� ��� 
mi_selectlabel((Lkat+Lmag)*0.7*Vol,0)				-- �������� ����� �����
mi_setblockprop("Air", 1, "", "", "",0) 			-- ������������� �������� ����� � ����� Air � ������� ����� 0

mi_zoomnatural()	-- ������������� ��� ��� ��� �� ���� ����� �� ���� �����

-------------------------------------------------------------------------- ������� ����
if Dstvola < Dpuli then Dstvola = Dpuli+0.1 end -- ������ �� ������ 

-- ���� ����� ���� ����� �������� ������ ���
if Lpuli==Dpuli then 

	mi_addnode(0,Lkat/2-Lsdv)
	mi_addnode(0,Lkat/2+Lpuli-Lsdv)

	mi_clearselected()
	mi_selectnode (0,Lkat/2-Lsdv)
	mi_selectnode (0,Lkat/2+Lpuli-Lsdv)
	mi_setnodeprop("",1)

	mi_addarc(0,Lkat/2-Lsdv,0,Lkat/2+Lpuli-Lsdv,180,5)


else	-- ����� ������ �������

	mi_addnode(0,Lkat/2-Lsdv)
	mi_addnode(Dpuli/2,Lkat/2-Lsdv)
	mi_addnode(Dpuli/2,Lkat/2+Lpuli-Lsdv)
	mi_addnode(0,Lkat/2+Lpuli-Lsdv)

	mi_clearselected()
	mi_selectnode(0,Lkat/2-Lsdv)
	mi_selectnode(Dpuli/2,Lkat/2-Lsdv)
	mi_selectnode(Dpuli/2,Lkat/2+Lpuli-Lsdv)
	mi_selectnode(0,Lkat/2+Lpuli-Lsdv)
	mi_setnodeprop("",1)

	mi_addsegment(Dpuli/2,Lkat/2-Lsdv,Dpuli/2,Lkat/2+Lpuli-Lsdv)
	mi_addsegment(Dpuli/2,Lkat/2+Lpuli-Lsdv,0,Lkat/2+Lpuli-Lsdv)
	mi_addsegment(0,Lkat/2+Lpuli-Lsdv,0,Lkat/2-Lsdv)
	mi_addsegment(0,Lkat/2-Lsdv,Dpuli/2,Lkat/2-Lsdv)

end
mi_addblocklabel(Dpuli/4,Lkat/2+Lpuli/2-Lsdv)
mi_clearselected()
mi_selectlabel(Dpuli/4,Lkat/2+Lpuli/2-Lsdv)
mi_setblockprop(Material_puli, 0, Proj_meshsize, "", "",1)			-- ����� ����� 1


------------------------------------------------------------------------- ������� �������

mi_addnode(Dstvola/2,Lkat/2)			-- ���������
mi_addnode(Dstvola/2,-Lkat/2)			-- ���������
mi_addnode(Dkat/2,Lkat/2)				-- ������� ��������� �����
mi_addnode(Dkat/2,-Lkat/2)				-- ������� �������� �����


mi_clearselected()
mi_selectnode(Dstvola/2,Lkat/2)			-- ���������
mi_selectnode(Dstvola/2,-Lkat/2)		-- ���������
mi_selectnode(Dkat/2,Lkat/2)				
mi_selectnode(Dkat/2,-Lkat/2)				
mi_setnodeprop("",2)

mi_addsegment(Dstvola/2,-Lkat/2,Dstvola/2,Lkat/2)
mi_addsegment(Dstvola/2,Lkat/2,Dkat/2,Lkat/2)
mi_addsegment(Dkat/2,Lkat/2,Dkat/2,-Lkat/2)
mi_addsegment(Dkat/2,-Lkat/2,Dstvola/2,-Lkat/2)


mi_addblocklabel(Dstvola/2+(Dkat/2-Dstvola/2)/2,0)
mi_clearselected()
mi_selectlabel(Dstvola/2+(Dkat/2-Dstvola/2)/2,0)
mi_setblockprop("Cu", 0, Coil_meshsize, "katushka", "",2) -- ����� ����� 2


-------------------------------------------------------------------------- ������� ������� �������������
if (Lmag > 0) and (Nom_mat_magnitoprovoda > 0) then 

	
	mi_addnode(Dstvola/2,Lkat/2+Lmag)
	mi_addnode(Dkat/2+Lmag,Lkat/2+Lmag)
	mi_addnode(Dkat/2+Lmag,-Lkat/2-Lmag)	
	mi_addnode(Dstvola/2,-Lkat/2-Lmag)

	mi_clearselected()
	mi_selectnode(Dstvola/2,Lkat/2+Lmag)			-- ���������
	mi_selectnode(Dkat/2+Lmag,Lkat/2+Lmag)		-- ���������
	mi_selectnode(Dkat/2+Lmag,-Lkat/2-Lmag)				
	mi_selectnode(Dstvola/2,-Lkat/2-Lmag)				
	mi_setnodeprop("",3)	


	mi_addsegment(Dstvola/2,Lkat/2,Dstvola/2,Lkat/2+Lmag)
	mi_addsegment(Dstvola/2,Lkat/2+Lmag,Dkat/2+Lmag,Lkat/2+Lmag)
	mi_addsegment(Dkat/2+Lmag,Lkat/2+Lmag,Dkat/2+Lmag,-Lkat/2-Lmag)

	mi_addsegment(Dkat/2+Lmag,-Lkat/2-Lmag,Dstvola/2,-Lkat/2-Lmag)
	mi_addsegment(Dstvola/2,-Lkat/2-Lmag,Dstvola/2,-Lkat/2)

	mi_addblocklabel(Dkat/2+Lmag/2,0)
	mi_clearselected()
	mi_selectlabel(Dkat/2+Lmag/2,0)
	mi_setblockprop(Material_magnitoprovoda, 1, "", "", "",3)		-- ����� ����� 3

end

mi_clearselected()


--------------------------------------------------------------------------------
-- ������� �� - ����, �����
--------------------------------------------------------------------------------
C = C/1000000
Dpriz = Dpr+Tiz -- ������� ������� � ��������
Dpr = Dpr/1000
Dpriz = Dpriz/1000		
Lpuli  = Lpuli/1000
Dpuli = Dpuli/1000
Dstvola = Dstvola/1000				
Lkat = Lkat/1000
Dkat = Dkat/1000
Lsdv = Lsdv/1000
Lmag = Lmag/1000
--------------------------------------------------------------------------------

-- ����������� � ��������� �������������
	
mi_analyze(1)				-- ����������� (������� ���� ������� "1") 0 - ����� ����� ���� � ����� �������� ��������
mi_loadsolution()			-- ��������� ���� ��������� ���� ����������

mo_groupselectblock(2)
Skat = mo_blockintegral(5) 		-- ������� ������� �������, ����^2 
Vkat = mo_blockintegral(10)		-- ����� �������, ����^3
mo_clearblock()
mo_groupselectblock(1)
Vpuli = mo_blockintegral(10)		-- ����� ����, ����^3	
mo_clearblock()				


Mpuli=ro*Vpuli				-- ����� ����, ��
N=Skat*0.94/(Dpriz*Dpriz)		-- ���������� ������ � ������� ���������
DLprovoda=N * 2 * pi * (Dkat + Dstvola)/4   -- ����� ����������� ������� ���������, �

Rkat=sigma*DLprovoda/(pi*(Dpr/2)^2)	-- ������������� ����� ����������� ������� �������, ��
R=Rv+Rkat				-- ������ ������������� �������

--������������� ����� ������, � ���� ���� 100 � ��� ������ �������������

mi_clearselected()
mi_selectlabel(Dstvola*1000/2+(Dkat/2-Dstvola/2)*1000/2,0) 
mi_setblockprop("Cu", 0, Coil_meshsize, "katushka", "",2,N) -- ��������� �������� - ����� ������
mi_clearselected()
mi_modifycircprop("katushka",1,100)


-- ����������� � ��������� �������������

mi_analyze(1)				-- ����������� (������� ���� ������� "1") 	
mo_reload()				-- ������������� ��������� ���� ����������			
current_re,current_im,volts_re,volts_im,flux_re,flux_im=mo_getcircuitproperties("katushka") -- �������� ������ � �������


L=flux_re/current_re			-- ��������� �������������, �����

--------------------------------------------------------------------------------
-- ������ ���������
--------------------------------------------------------------------------------

dt = delta_t/1000000 -- ������� ���������� ������� � ������� 
x=0		-- ��������� ������� ����
I0=0.00000001   -- ���������� ����� �������� ����
t=0		-- ����� �����
Vel=Vel0
Vmax=Vel
Uc = U
I=I0		-- ��������� �������� ����
Force = 0
Fii = 0
Fix = 0
KC=1		-- ������� ������, ��� ������ � ����
T_I={}		-- ������� ������ (������� ��� � �������� � Lua)
T_F={}		
T_Vel={}	
T_x={}		
T_t={}
showconsole()							-- ���������� ���� ������ ������������� ������
clearconsole()

repeat  	------------------------------------------------------------ �������� ����
	
	t = t+dt
	--- ������������ dFi/dI ��� I � ����
            mi_modifycircprop("katushka",1,I)	-- ������������� ��� 
            mi_analyze(1)			-- ����������� (������� ���� ������� "1") 0 - ����� ����� ���� � ����� �������� ��������	
            mo_reload()				-- ������������� ��������� ���� ����������
            mo_groupselectblock(1)

	Force = mo_blockintegral(19)		-- ���� ����������� �� ����, ������	
	Force=Force*-1				-- ������ "-" �� �� ��������� (����������� ���� � ������� ���������� ����������)
			
	current_re,current_im,volts_re,volts_im,flux_re,flux_im=mo_getcircuitproperties("katushka") -- �������� ������ � �������
	Fi0=flux_re			            -- ��������� �����
        mi_modifycircprop("katushka",1,I*1.001)	-- ������������� ���, ����������� �� 1.001
        mi_analyze(1)				-- ����������� (������� ���� ������� "1") 0 - ����� ����� ���� � ����� �������� ��������	
        mo_reload()				-- ������������� ��������� ���� ����������			
	current_re,current_im,volts_re,volts_im,flux_re,flux_im=mo_getcircuitproperties("katushka") -- �������� ������ � �������

	Fi1=flux_re			            -- ��������� ����� ��� I=I+0.001*I, dI=0.001*I 
	Fii=(Fi1-Fi0)/(0.001*I)                              -- ������������ dFi/dI

	apuli = Force / Mpuli			-- ��������� ����, ����/�������^2 
	dx = Vel*dt+apuli*dt*dt/2		-- ���������� ����������, ����
	x = x+dx				-- ����� ������� ����
	Vel = Vel+apuli*dt			-- �������� ����� ����������, ����/�������
	
	if Vmax<Vel then Vmax=Vel end



	--- ������������ dFi/dx ��� x
           
	Fix= Force/I
	------- ����������� ��� � ���������� �� ������������

	I=I+dt*(Uc-I*R-Fix*Vel)/Fii				

	Uc = Uc-dt*I/C


	if Uc< U*0.2 then  break end 

	Epuli = (Mpuli*Vel^2)/2 - (Mpuli*Vel0^2)/2
	EC= (C*U^2)/2
	KPD = Epuli*100/EC

  
	print (KPD .. " - % ���; " .. Vel .. " �/�; " .. I .. " �����; " .. Uc .. " �����; " .. Force .. " ������")


	T_I[KC]=I		-- ���������� ������ � ������

	T_F[KC]=Force		

	T_Vel[KC]=Vel		

	T_x[KC]=x*1000		

	T_t[KC]=t*1000000	

	KC=KC+1

until I<0 -- ��������� ������, ���� �� ����� �������

Epuli = (Mpuli*Vel^2)/2 - (Mpuli*Vel0^2)/2
EC= (C*U^2)/2
KPD = Epuli*100/EC

showconsole()							-- ���������� ���� ������ ������������� ������
clearconsole()
print ("-----------------------------------")						
print ("������ ��������� " .. Start_date)
print ("������� ������������, ����������= " .. C*1000000)
print ("���������� �� ������������, ����� = " .. U)
print ("������������� �����, �� = "..R)
print ("������� �������������, �� = " .. Rv)
print ("������������� �������, O� = "..Rkat)
print ("���������� ������ � ������� = "..N)
print ("������� ����������� ������� �������, �������� = " .. Dpr*1000)
print ("����� ������� � �������, ���� = "..DLprovoda)
print ("����� �������, �������� = " .. Lkat*1000)
print ("������� ������� �������, �������� = " .. Dkat*1000)
print ("������������� ������� � ����� � ��������� ���������, ����������= "..L*1000000)
print ("������� �������� ��������������, �������� = " .. Lmag*1000)
print ("�������� �������� �������������� ������� = � " .. Nom_mat_magnitoprovoda .. " " .. vyvod_name_materiala(Nom_mat_magnitoprovoda))
print ("������� ������� ������, �������� = " .. Dstvola*1000)	
print ("����� ����, ����� = "..Mpuli*1000)
print ("����� ����, �������� = " .. Lpuli*1000)		
print ("������� ����, �������� = " .. Dpuli*1000)
print ("����������, �� ������� � ��������� ������ �������� ���� � �������, �������� = " .. Lsdv*1000)	
print ("�������� �� ������� ������� ���� = � " .. Nom_mat_puli .. " " .. vyvod_name_materiala(Nom_mat_puli))
print ("����� �������� (��������)= " .. t*1000000)
print ("���������� �������,  ��������=" .. delta_t)
print ("������� ���� �� = " .. Epuli)
print ("������� ������������ �� = " .. EC)
print ("��� �����(%)= " .. KPD )
print ("��������� �������� ����, �/� = " .. Vel0)
print ("�������� ���� �� ������ �� �������, �/�= " .. Vel )
print ("������������ ��������, ������� ���� ����������, �/� = " .. Vmax )
print ("��� ������ � ������������� �������� � ����: " .. File_name .. " V = " .. Vel .. ".txt")
print ("��������� ��������� " .. date())


----------------------------------------------------------------------------------------------------
-- ���������� �� � ����
----------------------------------------------------------------------------------------------------
handle = openfile(File_name .. " V = " .. Vel .. ".txt", "a")-- ������� ���� � - ����� ���������� � ����� ����� w - �������� ������ �� ��� ���� ����� ���

write (handle,"--------------------------------------------------------------------------------\n")
write (handle,"������ ��������� " .. Start_date,"\n")
write (handle,"������� ������������, ����������= " .. C*1000000,"\n")
write (handle,"���������� �� ������������, ����� = " .. U,"\n")
write (handle,"������������� �����, �� = "..R,"\n")
write (handle,"������� �������������, �� = " .. Rv,"\n")
write (handle,"������������� �������, O� = "..Rkat,"\n")
write (handle,"���������� ������ � ������� = "..N,"\n")
write (handle,"������� ����������� ������� �������, �������� = " .. Dpr*1000,"\n")
write (handle,"����� ������� � �������, ���� = "..DLprovoda,"\n")
write (handle,"����� �������, �������� = " .. Lkat*1000,"\n")
write (handle,"������� ������� �������, �������� = " .. Dkat*1000,"\n")
write (handle,"������������� ������� � ����� � ��������� ���������, ����������= "..L*1000000,"\n")
write (handle,"������� �������� ��������������, �������� = " .. Lmag*1000,"\n")
write (handle,"�������� �������� �������������� ������� = � " .. Nom_mat_magnitoprovoda .. " " .. vyvod_name_materiala(Nom_mat_magnitoprovoda),"\n")
write (handle,"������� ������� ������, �������� = " .. Dstvola*1000,"\n")
write (handle,"����� ����, ����� = "..Mpuli*1000,"\n")
write (handle,"����� ����, �������� = " .. Lpuli*1000,"\n")		
write (handle,"������� ����, �������� = " .. Dpuli*1000,"\n")
write (handle,"����������, �� ������� � ��������� ������ �������� ���� � �������, �������� = " .. Lsdv*1000,"\n")
write (handle,"�������� �� ������� ������� ���� = � " .. Nom_mat_puli .. " " .. vyvod_name_materiala(Nom_mat_puli),"\n")
write (handle,"����� �������� (��������)= " .. t*1000000,"\n")
write (handle,"���������� �������,  ��������=" .. delta_t,"\n")
write (handle,"������� ���� �� = " .. Epuli,"\n")
write (handle,"������� ������������ �� = " .. EC,"\n")
write (handle,"��� �����(%)= " .. KPD,"\n")
write (handle,"��������� �������� ����, �/� = " .. Vel0,"\n")
write (handle,"�������� ���� �� ������ �� �������, �/�= " .. Vel,"\n")
write (handle,"������������ ��������, ������� ���� ����������, �/� = " .. Vmax,"\n")
write (handle,"��������� ��������� " .. date(),"\n")
write (handle,"-------------------------------������������� ������---------------------------------\n")
write (handle,"���� ���� (�)		���� �. �� ���� (�)	�������� (�/�)		���������� �(��) 	����� (���) \n")

for Scet=1,KC-1 do
	write (handle,T_I[Scet],"\t",T_F[Scet],"\t",T_Vel[Scet],"\t",T_x[Scet],"\t",T_t[Scet],"\t","\n")
end
write (handle,"-- ������������� ������ ��� �������� --\n")
write (handle,"���� ���� (�)\n")
for Scet=1,KC-1 do
	data1,data2=gsub(T_I[Scet], "%.", ",")
	write (handle,data1,"\n")
end
write (handle,"���� �. �� ���� (�)\n")
for Scet=1,KC-1 do
	data1,data2=gsub(T_F[Scet], "%.", ",")
	write (handle,data1,"\n")
end
write (handle,"�������� (�/�)\n")
for Scet=1,KC-1 do
	data1,data2=gsub(T_Vel[Scet], "%.", ",")
	write (handle,data1,"\n")
end
write (handle,"���������� �(��)\n")
for Scet=1,KC-1 do
	data1,data2=gsub(T_x[Scet], "%.", ",")
	write (handle,data1,"\n")
end
write (handle,"����� (���)\n")
for Scet=1,KC-1 do
	data1,data2=gsub(T_t[Scet], "%.", ",")
	write (handle,data1,"\n")
end
closefile(handle)

-- ������� ������������� �����
remove ("temp.fem")
remove ("temp.ans")

