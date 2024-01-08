classdef tcpip_cliente_pc1
    properties
        %Propiedades que cambian solo con fclose(obj)
        ip
        puerto
        rol
        buffer_in
        buffer_out
        obj_tcpip
        %Propiedad que se puede cambiar en cualquier momento
        tiempo
        %Propiedades de lectura que se actualizan
        dato_lectura
        dato_escritura
        estado_comunicacion
        estado_transferencia
        no_val_recibidos
        no_val_enviados
        %Lectura Base de Datos
        BD_leida
        ultimo_dato_lectura
        ultimo_dato_escritura
    end
    methods
        function t= hacer_com(obj)
            t = tcpip(obj.ip, obj.puerto, 'NetworkRole', obj.rol);
            t.Timeout=obj.tiempo;
            t.InputBufferSize=obj.buffer_in;
            t.OutputBufferSize=obj.buffer_out;
        end
        
        function abrir_comunicacion(obj)
            fopen(obj.obj_tcpip);
        end
        
        function terminar_comunicacion(obj)
            fclose(obj.obj_tcpip);
        end
        
        % Operación de lectura server_1 - S: 2B - C:nB
        function l=lectura_datos_2(obj)
            l=fread(obj.obj_tcpip,1,'uint16');
        end
        
        % Operación de lectura server_1 - S: 1B - C:nB
        function l=lectura_datos_1(obj)
            l=fread(obj.obj_tcpip);
        end
        
        % Operación de lectura server_1 - S: 170B - C:nB
        function l=lectura_datos_170(obj)
            l=fread(obj.obj_tcpip,170,'uint8');
        end
        
        % Operación de lectura server_1 - S: 170B - C:nB
        function l=lectura_datos_190(obj)
            l=fread(obj.obj_tcpip,190,'uint8');
        end
        
        % Operación de lectura server_1 - S: 256B - C:nB
        function l=lectura_datos_256(obj)
            l=fread(obj.obj_tcpip,256,'uint8');
        end
        
        % Operación de lectura server_1 - S: 512B - C:nB
        function l=lectura_datos_512(obj)
            l=fread(obj.obj_tcpip,512,'uint8');
        end
        
        % Operación de lectura server_1 - S: 1024B - C:nB
        function l=lectura_datos_1024(obj)
            l=fread(obj.obj_tcpip,1024,'uint8');
        end
        
        % Operación de lectura server_1 - S: 2048B - C:nB
        function l=lectura_datos_2048(obj)
            l=fread(obj.obj_tcpip,2048,'uint8');
        end
        
        % Operación de lectura server_1 - S: 4096B - C:nB
        function l=lectura_datos_4096(obj)
            l=fread(obj.obj_tcpip,4096,'uint8');
        end
        
        % Operación de escritura server_1 - S: 2B - C:nB
        function escritura_datos_n(obj,d)
            fwrite(obj.obj_tcpip,d,'uint16');
        end
        
        % Operación de escritura server_1 - S: 2B - C:nB
        function escritura_datos_1(obj,d)
            fwrite(obj.obj_tcpip,d,'uint8');
        end
        
        function [st_com, st_trans, no_val_recibidos, no_val_enviados]=actualizacion_informacion(obj)
            st_com=obj.obj_tcpip.Status;
            st_trans=obj.obj_tcpip.TransferStatus;
            no_val_recibidos=obj.obj_tcpip.ValuesReceived;
            no_val_enviados= obj.obj_tcpip.ValuesSent;
        end
        
        % Función para organización de los datos de lectura - S: 160B - C:6B
        
        function [CONF1,K1,ALFA1,B1,PS1,TMS1,TINS1,ESC1,CONF2,K2,ALFA2,B2,PS2,TMS2,TINS2,ESC2,CONF3,K3,ALFA3,B3,PS3,TMS3,TINS3,ESC3,CONF4,K4,ALFA4,B4,PS4,TMS4,TINS4,ESC4,CONF5,K5,ALFA5,B5,PS5,TMS5,TINS5,ESC5]=arreglo_datos_s160_c6(obj)
            CONF1=obj.dato_lectura(1)+(obj.dato_lectura(2))/1e4;
            K1=obj.dato_lectura(3)+(obj.dato_lectura(4))/1e4;
            ALFA1=obj.dato_lectura(5)+(obj.dato_lectura(6))/1e4;
            B1=obj.dato_lectura(7)+(obj.dato_lectura(8))/1e4;
            PS1=obj.dato_lectura(9)+(obj.dato_lectura(10))/1e4;
            TMS1=obj.dato_lectura(11)+(obj.dato_lectura(12))/1e4;
            TINS1=obj.dato_lectura(13)+(obj.dato_lectura(14))/1e4;
            ESC1=obj.dato_lectura(15)+(obj.dato_lectura(16))/1e4;
            
            CONF2=obj.dato_lectura(17)+(obj.dato_lectura(18))/1e4;
            K2=obj.dato_lectura(19)+(obj.dato_lectura(20))/1e4;
            ALFA2=obj.dato_lectura(21)+(obj.dato_lectura(22))/1e4;
            B2=obj.dato_lectura(23)+(obj.dato_lectura(24))/1e4;
            PS2=obj.dato_lectura(25)+(obj.dato_lectura(26))/1e4;
            TMS2=obj.dato_lectura(27)+(obj.dato_lectura(28))/1e4;
            TINS2=obj.dato_lectura(29)+(obj.dato_lectura(30))/1e4;
            ESC2=obj.dato_lectura(31)+(obj.dato_lectura(32))/1e4;
            
            CONF3=obj.dato_lectura(33)+(obj.dato_lectura(34))/1e4;
            K3=obj.dato_lectura(35)+(obj.dato_lectura(36))/1e4;
            ALFA3=obj.dato_lectura(37)+(obj.dato_lectura(38))/1e4;
            B3=obj.dato_lectura(39)+(obj.dato_lectura(40))/1e4;
            PS3=obj.dato_lectura(41)+(obj.dato_lectura(42))/1e4;
            TMS3=obj.dato_lectura(43)+(obj.dato_lectura(44))/1e4;
            TINS3=obj.dato_lectura(45)+(obj.dato_lectura(46))/1e4;
            ESC3=obj.dato_lectura(47)+(obj.dato_lectura(48))/1e4;
            
            CONF4=obj.dato_lectura(49)+(obj.dato_lectura(50))/1e4;
            K4=obj.dato_lectura(51)+(obj.dato_lectura(52))/1e4;
            ALFA4=obj.dato_lectura(53)+(obj.dato_lectura(54))/1e4;
            B4=obj.dato_lectura(55)+(obj.dato_lectura(56))/1e4;
            PS4=obj.dato_lectura(57)+(obj.dato_lectura(58))/1e4;
            TMS4=obj.dato_lectura(59)+(obj.dato_lectura(60))/1e4;
            TINS4=obj.dato_lectura(61)+(obj.dato_lectura(62))/1e4;
            ESC4=obj.dato_lectura(63)+(obj.dato_lectura(64))/1e4;
            
            CONF5=obj.dato_lectura(65)+(obj.dato_lectura(66))/1e4;
            K5=obj.dato_lectura(67)+(obj.dato_lectura(68))/1e4;
            ALFA5=obj.dato_lectura(69)+(obj.dato_lectura(70))/1e4;
            B5=obj.dato_lectura(71)+(obj.dato_lectura(72))/1e4;
            PS5=obj.dato_lectura(73)+(obj.dato_lectura(74))/1e4;
            TMS5=obj.dato_lectura(75)+(obj.dato_lectura(76))/1e4;
            TINS5=obj.dato_lectura(77)+(obj.dato_lectura(78))/1e4;
            ESC5=obj.dato_lectura(79)+(obj.dato_lectura(80))/1e4;
        end
        
        function [CONF1,K1,ALFA1,B1,PS1,TMS1,TINS1,ESC1,CONF2,K2,ALFA2,B2,PS2,TMS2,TINS2,ESC2,CONF3,K3,ALFA3,B3,PS3,TMS3,TINS3,ESC3,CONF4,K4,ALFA4,B4,PS4,TMS4,TINS4,ESC4,CONF5,K5,ALFA5,B5,PS5,TMS5,TINS5,ESC5]=arreglo_datos_s170_c6(obj)
            z=char(reshape(obj.dato_lectura,[1,170]));
            
            if str2double(z(1)) == 1
                x=z(20:170);
                j=0;
                p=[];
                for i = 1:length(x)
                    if x(i) == ','
                        j=j+1;
                        p(j)=i; %#ok<AGROW>
                    end
                end
                num_cha_anterior=0;
                y=[];
                for r= 1:40
                    num_cha=p(r+1)-p(r)-1;
                    captura_cha=blanks(num_cha);
                    for w=1:num_cha
                        captura_cha(w)=x(r+w+num_cha_anterior);
                    end
                    y(r)=str2double(captura_cha); %#ok<AGROW>
                    num_cha_anterior=num_cha+num_cha_anterior;
                end
            end
            
            if str2double(z(1)) == 2
                x=z(10:170);
                j=0;
                p=[];
                for i = 1:length(x)
                    if x(i) == ','
                        j=j+1;
                        p(j)=i; %#ok<AGROW>
                    end
                end
                num_cha_anterior=0;
                y=[];
                for r= 1:40
                    num_cha=p(r+1)-p(r)-1;
                    captura_cha=blanks(num_cha);
                    for w=1:num_cha
                        captura_cha(w)=x(r+w+num_cha_anterior);
                    end
                    y(r)=str2double(captura_cha); %#ok<AGROW>
                    num_cha_anterior=num_cha+num_cha_anterior;
                end
            end
            
            CONF1=y(1);
            K1=y(2);
            ALFA1=y(3);
            B1=y(4);
            PS1=y(5);
            TMS1=y(6);
            TINS1=y(7);
            ESC1=y(8);
            
            CONF2=y(9);
            K2=y(10);
            ALFA2=y(11);
            B2=y(12);
            PS2=y(13);
            TMS2=y(14);
            TINS2=y(15);
            ESC2=y(16);
            
            CONF3=y(17);
            K3=y(18);
            ALFA3=y(19);
            B3=y(20);
            PS3=y(21);
            TMS3=y(22);
            TINS3=y(23);
            ESC3=y(24);
            
            CONF4=y(25);
            K4=y(26);
            ALFA4=y(27);
            B4=y(28);
            PS4=y(29);
            TMS4=y(30);
            TINS4=y(31);
            ESC4=y(32);
            
            CONF5=y(33);
            K5=y(34);
            ALFA5=y(35);
            B5=y(36);
            PS5=y(37);
            TMS5=y(38);
            TINS5=y(39);
            ESC5=y(40);
        end
        
        function [CONF1,K1,ALFA1,B1,PS1,TMS1,TINS1,ESC1,CONF2,K2,ALFA2,B2,PS2,TMS2,TINS2,ESC2,CONF3,K3,ALFA3,B3,PS3,TMS3,TINS3,ESC3,CONF4,K4,ALFA4,B4,PS4,TMS4,TINS4,ESC4,CONF5,K5,ALFA5,B5,PS5,TMS5,TINS5,ESC5]=arreglo_datos_s190_c6(obj)
            z=char(reshape(obj.dato_lectura,[1,190]));
            
            if str2double(z(1)) == 1
                x=z(15:190);
                j=0;
                p=[];
                for i = 1:length(x)
                    if x(i) == ','
                        j=j+1;
                        p(j)=i; %#ok<AGROW>
                    end
                end
                num_cha_anterior=0;
                y=[];
                for r= 1:40
                    num_cha=p(r+1)-p(r)-1;
                    captura_cha=blanks(num_cha);
                    for w=1:num_cha
                        captura_cha(w)=x(r+w+num_cha_anterior);
                    end
                    y(r)=str2double(captura_cha); %#ok<AGROW>
                    num_cha_anterior=num_cha+num_cha_anterior;
                end
            end
            
            if str2double(z(1)) == 2
                x=z(15:190);
                j=0;
                p=[];
                for i = 1:length(x)
                    if x(i) == ','
                        j=j+1;
                        p(j)=i; %#ok<AGROW>
                    end
                end
                num_cha_anterior=0;
                y=[];
                for r= 1:40
                    num_cha=p(r+1)-p(r)-1;
                    captura_cha=blanks(num_cha);
                    for w=1:num_cha
                        captura_cha(w)=x(r+w+num_cha_anterior);
                    end
                    y(r)=str2double(captura_cha); %#ok<AGROW>
                    num_cha_anterior=num_cha+num_cha_anterior;
                end
            end
            
            CONF1=y(1);
            K1=y(2);
            ALFA1=y(3);
            B1=y(4);
            PS1=y(5);
            TMS1=y(6);
            TINS1=y(7);
            ESC1=y(8);
            
            CONF2=y(9);
            K2=y(10);
            ALFA2=y(11);
            B2=y(12);
            PS2=y(13);
            TMS2=y(14);
            TINS2=y(15);
            ESC2=y(16);
            
            CONF3=y(17);
            K3=y(18);
            ALFA3=y(19);
            B3=y(20);
            PS3=y(21);
            TMS3=y(22);
            TINS3=y(23);
            ESC3=y(24);
            
            CONF4=y(25);
            K4=y(26);
            ALFA4=y(27);
            B4=y(28);
            PS4=y(29);
            TMS4=y(30);
            TINS4=y(31);
            ESC4=y(32);
            
            CONF5=y(33);
            K5=y(34);
            ALFA5=y(35);
            B5=y(36);
            PS5=y(37);
            TMS5=y(38);
            TINS5=y(39);
            ESC5=y(40);
        end
        
        function [CONF1,K1,ALFA1,B1,PS1,TMS1,TINS1,ESC1,CONF2,K2,ALFA2,B2,PS2,TMS2,TINS2,ESC2,CONF3,K3,ALFA3,B3,PS3,TMS3,TINS3,ESC3,CONF4,K4,ALFA4,B4,PS4,TMS4,TINS4,ESC4,CONF5,K5,ALFA5,B5,PS5,TMS5,TINS5,ESC5,adicional]=arreglo_datos_s256_c6(obj)
            z=char(reshape(obj.dato_lectura,[1,256]));
            
            if str2double(z(1)) == 1
                x=z(15:256);
                j=0;
                p=[];
                for i = 1:length(x)
                    if x(i) == ','
                        j=j+1;
                        p(j)=i; %#ok<AGROW>
                    end
                end
                num_cha_anterior=0;
                y=[];
                for r= 1:41
                    num_cha=p(r+1)-p(r)-1;
                    captura_cha=blanks(num_cha);
                    for w=1:num_cha
                        captura_cha(w)=x(r+w+num_cha_anterior);
                    end
                    y(r)=str2double(captura_cha); %#ok<AGROW>
                    num_cha_anterior=num_cha+num_cha_anterior;
                end
            end
            
            if str2double(z(1)) == 2
                x=z(15:256);
                j=0;
                p=[];
                for i = 1:length(x)
                    if x(i) == ','
                        j=j+1;
                        p(j)=i; %#ok<AGROW>
                    end
                end
                num_cha_anterior=0;
                y=[];
                for r= 1:41
                    num_cha=p(r+1)-p(r)-1;
                    captura_cha=blanks(num_cha);
                    for w=1:num_cha
                        captura_cha(w)=x(r+w+num_cha_anterior);
                    end
                    y(r)=str2double(captura_cha); %#ok<AGROW>
                    num_cha_anterior=num_cha+num_cha_anterior;
                end
            end
            
            CONF1=y(1);
            K1=y(2);
            ALFA1=y(3);
            B1=y(4);
            PS1=y(5);
            TMS1=y(6);
            TINS1=y(7);
            ESC1=y(8);
            
            CONF2=y(9);
            K2=y(10);
            ALFA2=y(11);
            B2=y(12);
            PS2=y(13);
            TMS2=y(14);
            TINS2=y(15);
            ESC2=y(16);
            
            CONF3=y(17);
            K3=y(18);
            ALFA3=y(19);
            B3=y(20);
            PS3=y(21);
            TMS3=y(22);
            TINS3=y(23);
            ESC3=y(24);
            
            CONF4=y(25);
            K4=y(26);
            ALFA4=y(27);
            B4=y(28);
            PS4=y(29);
            TMS4=y(30);
            TINS4=y(31);
            ESC4=y(32);
            
            CONF5=y(33);
            K5=y(34);
            ALFA5=y(35);
            B5=y(36);
            PS5=y(37);
            TMS5=y(38);
            TINS5=y(39);
            ESC5=y(40);
            
            adicional=y(41);
        end
        
        function [CONF1,K1,ALFA1,B1,PS1,TMS1,TINS1,ESC1,CONF2,K2,ALFA2,B2,PS2,TMS2,TINS2,ESC2,CONF3,K3,ALFA3,B3,PS3,TMS3,TINS3,ESC3,CONF4,K4,ALFA4,B4,PS4,TMS4,TINS4,ESC4,CONF5,K5,ALFA5,B5,PS5,TMS5,TINS5,ESC5,adicional]=arreglo_datos_s512_c6(obj)
            z=char(reshape(obj.dato_lectura,[1,512]));
            
            if str2double(z(1)) == 1
                x=z(20:512);
                j=0;
                p=[];
                for i = 1:length(x)
                    if x(i) == ','
                        j=j+1;
                        p(j)=i; %#ok<AGROW>
                    end
                end
                num_cha_anterior=0;
                y=[];
                for r= 1:41
                    num_cha=p(r+1)-p(r)-1;
                    captura_cha=blanks(num_cha);
                    for w=1:num_cha
                        captura_cha(w)=x(r+w+num_cha_anterior);
                    end
                    y(r)=str2double(captura_cha); %#ok<AGROW>
                    num_cha_anterior=num_cha+num_cha_anterior;
                end
            end
            
            if str2double(z(1)) == 2
                x=z(10:512);
                j=0;
                p=[];
                for i = 1:length(x)
                    if x(i) == ','
                        j=j+1;
                        p(j)=i; %#ok<AGROW>
                    end
                end
                num_cha_anterior=0;
                y=[];
                for r= 1:41
                    num_cha=p(r+1)-p(r)-1;
                    captura_cha=blanks(num_cha);
                    for w=1:num_cha
                        captura_cha(w)=x(r+w+num_cha_anterior);
                    end
                    y(r)=str2double(captura_cha); %#ok<AGROW>
                    num_cha_anterior=num_cha+num_cha_anterior;
                end
            end
            
            CONF1=y(1);
            K1=y(2);
            ALFA1=y(3);
            B1=y(4);
            PS1=y(5);
            TMS1=y(6);
            TINS1=y(7);
            ESC1=y(8);
            
            CONF2=y(9);
            K2=y(10);
            ALFA2=y(11);
            B2=y(12);
            PS2=y(13);
            TMS2=y(14);
            TINS2=y(15);
            ESC2=y(16);
            
            CONF3=y(17);
            K3=y(18);
            ALFA3=y(19);
            B3=y(20);
            PS3=y(21);
            TMS3=y(22);
            TINS3=y(23);
            ESC3=y(24);
            
            CONF4=y(25);
            K4=y(26);
            ALFA4=y(27);
            B4=y(28);
            PS4=y(29);
            TMS4=y(30);
            TINS4=y(31);
            ESC4=y(32);
            
            CONF5=y(33);
            K5=y(34);
            ALFA5=y(35);
            B5=y(36);
            PS5=y(37);
            TMS5=y(38);
            TINS5=y(39);
            ESC5=y(40);
            
            adicional=y(41);
        end
        
        function [CONF1,K1,ALFA1,B1,PS1,TMS1,TINS1,ESC1,CONF2,K2,ALFA2,B2,PS2,TMS2,TINS2,ESC2,CONF3,K3,ALFA3,B3,PS3,TMS3,TINS3,ESC3,CONF4,K4,ALFA4,B4,PS4,TMS4,TINS4,ESC4,CONF5,K5,ALFA5,B5,PS5,TMS5,TINS5,ESC5,adicional]=arreglo_datos_s1024_c6(obj)
            z=char(reshape(obj.dato_lectura,[1,1024]));
            
            if str2double(z(1)) == 1
                x=z(20:1024);
                j=0;
                p=[];
                for i = 1:length(x)
                    if x(i) == ','
                        j=j+1;
                        p(j)=i; %#ok<AGROW>
                    end
                end
                num_cha_anterior=0;
                y=[];
                for r= 1:41
                    num_cha=p(r+1)-p(r)-1;
                    captura_cha=blanks(num_cha);
                    for w=1:num_cha
                        captura_cha(w)=x(r+w+num_cha_anterior);
                    end
                    y(r)=str2double(captura_cha); %#ok<AGROW>
                    num_cha_anterior=num_cha+num_cha_anterior;
                end
            end
            
            if str2double(z(1)) == 2
                x=z(10:1024);
                j=0;
                p=[];
                for i = 1:length(x)
                    if x(i) == ','
                        j=j+1;
                        p(j)=i; %#ok<AGROW>
                    end
                end
                num_cha_anterior=0;
                y=[];
                for r= 1:41
                    num_cha=p(r+1)-p(r)-1;
                    captura_cha=blanks(num_cha);
                    for w=1:num_cha
                        captura_cha(w)=x(r+w+num_cha_anterior);
                    end
                    y(r)=str2double(captura_cha); %#ok<AGROW>
                    num_cha_anterior=num_cha+num_cha_anterior;
                end
            end
            
            CONF1=y(1);
            K1=y(2);
            ALFA1=y(3);
            B1=y(4);
            PS1=y(5);
            TMS1=y(6);
            TINS1=y(7);
            ESC1=y(8);
            
            CONF2=y(9);
            K2=y(10);
            ALFA2=y(11);
            B2=y(12);
            PS2=y(13);
            TMS2=y(14);
            TINS2=y(15);
            ESC2=y(16);
            
            CONF3=y(17);
            K3=y(18);
            ALFA3=y(19);
            B3=y(20);
            PS3=y(21);
            TMS3=y(22);
            TINS3=y(23);
            ESC3=y(24);
            
            CONF4=y(25);
            K4=y(26);
            ALFA4=y(27);
            B4=y(28);
            PS4=y(29);
            TMS4=y(30);
            TINS4=y(31);
            ESC4=y(32);
            
            CONF5=y(33);
            K5=y(34);
            ALFA5=y(35);
            B5=y(36);
            PS5=y(37);
            TMS5=y(38);
            TINS5=y(39);
            ESC5=y(40);
            
            adicional=y(41);
        end
        
        function [CONF1,K1,ALFA1,B1,PS1,TMS1,TINS1,ESC1,CONF2,K2,ALFA2,B2,PS2,TMS2,TINS2,ESC2,CONF3,K3,ALFA3,B3,PS3,TMS3,TINS3,ESC3,CONF4,K4,ALFA4,B4,PS4,TMS4,TINS4,ESC4,CONF5,K5,ALFA5,B5,PS5,TMS5,TINS5,ESC5,adicional]=arreglo_datos_s2048_c6(obj)
            z=char(reshape(obj.dato_lectura,[1,2048]));
            
            if str2double(z(1)) == 1
                x=z(20:2048);
                j=0;
                p=[];
                for i = 1:length(x)
                    if x(i) == ','
                        j=j+1;
                        p(j)=i; %#ok<AGROW>
                    end
                end
                num_cha_anterior=0;
                y=[];
                for r= 1:41
                    num_cha=p(r+1)-p(r)-1;
                    captura_cha=blanks(num_cha);
                    for w=1:num_cha
                        captura_cha(w)=x(r+w+num_cha_anterior);
                    end
                    y(r)=str2double(captura_cha); %#ok<AGROW>
                    num_cha_anterior=num_cha+num_cha_anterior;
                end
            end
            
            if str2double(z(1)) == 2
                x=z(10:2048);
                j=0;
                p=[];
                for i = 1:length(x)
                    if x(i) == ','
                        j=j+1;
                        p(j)=i; %#ok<AGROW>
                    end
                end
                num_cha_anterior=0;
                y=[];
                for r= 1:41
                    num_cha=p(r+1)-p(r)-1;
                    captura_cha=blanks(num_cha);
                    for w=1:num_cha
                        captura_cha(w)=x(r+w+num_cha_anterior);
                    end
                    y(r)=str2double(captura_cha); %#ok<AGROW>
                    num_cha_anterior=num_cha+num_cha_anterior;
                end
            end
            
            CONF1=y(1);
            K1=y(2);
            ALFA1=y(3);
            B1=y(4);
            PS1=y(5);
            TMS1=y(6);
            TINS1=y(7);
            ESC1=y(8);
            
            CONF2=y(9);
            K2=y(10);
            ALFA2=y(11);
            B2=y(12);
            PS2=y(13);
            TMS2=y(14);
            TINS2=y(15);
            ESC2=y(16);
            
            CONF3=y(17);
            K3=y(18);
            ALFA3=y(19);
            B3=y(20);
            PS3=y(21);
            TMS3=y(22);
            TINS3=y(23);
            ESC3=y(24);
            
            CONF4=y(25);
            K4=y(26);
            ALFA4=y(27);
            B4=y(28);
            PS4=y(29);
            TMS4=y(30);
            TINS4=y(31);
            ESC4=y(32);
            
            CONF5=y(33);
            K5=y(34);
            ALFA5=y(35);
            B5=y(36);
            PS5=y(37);
            TMS5=y(38);
            TINS5=y(39);
            ESC5=y(40);
            
            adicional=y(41);
        end
        
        function [CONF1,K1,ALFA1,B1,PS1,TMS1,TINS1,ESC1,CONF2,K2,ALFA2,B2,PS2,TMS2,TINS2,ESC2,CONF3,K3,ALFA3,B3,PS3,TMS3,TINS3,ESC3,CONF4,K4,ALFA4,B4,PS4,TMS4,TINS4,ESC4,CONF5,K5,ALFA5,B5,PS5,TMS5,TINS5,ESC5,adicional]=arreglo_datos_s4096_c6(obj)
            z=char(reshape(obj.dato_lectura,[1,4096]));
            
            if str2double(z(1)) == 1
                x=z(20:4096);
                j=0;
                p=[];
                for i = 1:length(x)
                    if x(i) == ','
                        j=j+1;
                        p(j)=i; %#ok<AGROW>
                    end
                end
                num_cha_anterior=0;
                y=[];
                for r= 1:41
                    num_cha=p(r+1)-p(r)-1;
                    captura_cha=blanks(num_cha);
                    for w=1:num_cha
                        captura_cha(w)=x(r+w+num_cha_anterior);
                    end
                    y(r)=str2double(captura_cha); %#ok<AGROW>
                    num_cha_anterior=num_cha+num_cha_anterior;
                end
            end
            
            if str2double(z(1)) == 2
                x=z(10:4096);
                j=0;
                p=[];
                for i = 1:length(x)
                    if x(i) == ','
                        j=j+1;
                        p(j)=i; %#ok<AGROW>
                    end
                end
                num_cha_anterior=0;
                y=[];
                for r= 1:41
                    num_cha=p(r+1)-p(r)-1;
                    captura_cha=blanks(num_cha);
                    for w=1:num_cha
                        captura_cha(w)=x(r+w+num_cha_anterior);
                    end
                    y(r)=str2double(captura_cha); %#ok<AGROW>
                    num_cha_anterior=num_cha+num_cha_anterior;
                end
            end
            
            CONF1=y(1);
            K1=y(2);
            ALFA1=y(3);
            B1=y(4);
            PS1=y(5);
            TMS1=y(6);
            TINS1=y(7);
            ESC1=y(8);
            
            CONF2=y(9);
            K2=y(10);
            ALFA2=y(11);
            B2=y(12);
            PS2=y(13);
            TMS2=y(14);
            TINS2=y(15);
            ESC2=y(16);
            
            CONF3=y(17);
            K3=y(18);
            ALFA3=y(19);
            B3=y(20);
            PS3=y(21);
            TMS3=y(22);
            TINS3=y(23);
            ESC3=y(24);
            
            CONF4=y(25);
            K4=y(26);
            ALFA4=y(27);
            B4=y(28);
            PS4=y(29);
            TMS4=y(30);
            TINS4=y(31);
            ESC4=y(32);
            
            CONF5=y(33);
            K5=y(34);
            ALFA5=y(35);
            B5=y(36);
            PS5=y(37);
            TMS5=y(38);
            TINS5=y(39);
            ESC5=y(40);
            
            adicional=y(41);
        end
            
        % Función para grabar los datos de llegada desde el servidor
        
        function grabar_datos_llegada_2(obj,nombre_bd)
            % Ciclo para preguntar por escritura y lectura vacía
            if isempty(obj.dato_lectura)==1
                obj.dato_lectura=999;
            end
            % Grabamos datos de lectura y escritura:
            base_datos=fopen(nombre_bd,'a');
            fprintf(base_datos,'%f %f %f %f %f %f %s %d\n',datevec(datetime('now','Format','yyyy:MM:dd:HH:mm:ss:SSS')),obj.rol,obj.dato_lectura);
            fclose(base_datos);
        end
        
        function grabar_datos_llegada_170(obj,nombre_bd)
            % Grabamos datos de lectura y escritura:
            base_datos=fopen(nombre_bd,'a');
            fprintf(base_datos,'%f %f %f %f %f %f %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n',datevec(datetime('now','Format','yyyy:MM:dd:HH:mm:ss:SSS')),obj.rol,obj.dato_lectura(1),obj.dato_lectura(2),obj.dato_lectura(3),obj.dato_lectura(4),obj.dato_lectura(5),obj.dato_lectura(6),obj.dato_lectura(7),obj.dato_lectura(8),obj.dato_lectura(9),obj.dato_lectura(10),obj.dato_lectura(11),obj.dato_lectura(12),obj.dato_lectura(13),obj.dato_lectura(14),obj.dato_lectura(15),obj.dato_lectura(16),obj.dato_lectura(17),obj.dato_lectura(18),obj.dato_lectura(19),obj.dato_lectura(20),obj.dato_lectura(21),obj.dato_lectura(22),obj.dato_lectura(23),obj.dato_lectura(24),obj.dato_lectura(25),obj.dato_lectura(26),obj.dato_lectura(27),obj.dato_lectura(28),obj.dato_lectura(29),obj.dato_lectura(30),obj.dato_lectura(31),obj.dato_lectura(32),obj.dato_lectura(33),obj.dato_lectura(34),obj.dato_lectura(35),obj.dato_lectura(36),obj.dato_lectura(37),obj.dato_lectura(38),obj.dato_lectura(39),obj.dato_lectura(40),obj.dato_lectura(41));
            fclose(base_datos);
        end
        
        function grabar_datos_llegada_190(obj,nombre_bd)
            % Grabamos datos de lectura y escritura:
            base_datos=fopen(nombre_bd,'a');
            fprintf(base_datos,'%f %f %f %f %f %f %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n',datevec(datetime('now','Format','yyyy:MM:dd:HH:mm:ss:SSS')),obj.rol,obj.dato_lectura(1),obj.dato_lectura(2),obj.dato_lectura(3),obj.dato_lectura(4),obj.dato_lectura(5),obj.dato_lectura(6),obj.dato_lectura(7),obj.dato_lectura(8),obj.dato_lectura(9),obj.dato_lectura(10),obj.dato_lectura(11),obj.dato_lectura(12),obj.dato_lectura(13),obj.dato_lectura(14),obj.dato_lectura(15),obj.dato_lectura(16),obj.dato_lectura(17),obj.dato_lectura(18),obj.dato_lectura(19),obj.dato_lectura(20),obj.dato_lectura(21),obj.dato_lectura(22),obj.dato_lectura(23),obj.dato_lectura(24),obj.dato_lectura(25),obj.dato_lectura(26),obj.dato_lectura(27),obj.dato_lectura(28),obj.dato_lectura(29),obj.dato_lectura(30),obj.dato_lectura(31),obj.dato_lectura(32),obj.dato_lectura(33),obj.dato_lectura(34),obj.dato_lectura(35),obj.dato_lectura(36),obj.dato_lectura(37),obj.dato_lectura(38),obj.dato_lectura(39),obj.dato_lectura(40),obj.dato_lectura(41));
            fclose(base_datos);
        end
        
        function grabar_datos_llegada_256(obj,nombre_bd)
            % Grabamos datos de lectura y escritura:
            base_datos=fopen(nombre_bd,'a');
            fprintf(base_datos,'%f %f %f %f %f %f %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n',datevec(datetime('now','Format','yyyy:MM:dd:HH:mm:ss:SSS')),obj.rol,obj.dato_lectura(1),obj.dato_lectura(2),obj.dato_lectura(3),obj.dato_lectura(4),obj.dato_lectura(5),obj.dato_lectura(6),obj.dato_lectura(7),obj.dato_lectura(8),obj.dato_lectura(9),obj.dato_lectura(10),obj.dato_lectura(11),obj.dato_lectura(12),obj.dato_lectura(13),obj.dato_lectura(14),obj.dato_lectura(15),obj.dato_lectura(16),obj.dato_lectura(17),obj.dato_lectura(18),obj.dato_lectura(19),obj.dato_lectura(20),obj.dato_lectura(21),obj.dato_lectura(22),obj.dato_lectura(23),obj.dato_lectura(24),obj.dato_lectura(25),obj.dato_lectura(26),obj.dato_lectura(27),obj.dato_lectura(28),obj.dato_lectura(29),obj.dato_lectura(30),obj.dato_lectura(31),obj.dato_lectura(32),obj.dato_lectura(33),obj.dato_lectura(34),obj.dato_lectura(35),obj.dato_lectura(36),obj.dato_lectura(37),obj.dato_lectura(38),obj.dato_lectura(39),obj.dato_lectura(40),obj.dato_lectura(41));
            fclose(base_datos);
        end
        
        % Funciones para grabar los datos de salida al servidor
        
        function grabar_datos_salida_2(obj,nombre_bd)
            % Ciclo para preguntar por escritura y lectura vacía
            if isempty(obj.dato_escritura)==1
                obj.dato_escritura=999;
            end
            % Grabamos datos de lectura y escritura:
            base_datos=fopen(nombre_bd,'a');
            fprintf(base_datos,'%f %f %f %f %f %f %s %d\n',datevec(datetime('now','Format','yyyy:MM:dd:HH:mm:ss:SSS')),obj.rol,obj.dato_escritura);
            fclose(base_datos);
        end
        
        function grabar_datos_salida_6(obj,nombre_bd)
            % Grabamos datos de lectura y escritura:
            base_datos=fopen(nombre_bd,'a');
            fprintf(base_datos,'%f %f %f %f %f %f %s %d %d %d %d %d %d\n',datevec(datetime('now','Format','yyyy:MM:dd:HH:mm:ss:SSS')),obj.rol,obj.dato_escritura(1),obj.dato_escritura(2),obj.dato_escritura(3),obj.dato_escritura(4),obj.dato_escritura(5),obj.dato_escritura(6));
            fclose(base_datos);
        end
        
        %Función para calcular el tiempo del ciclo de comunicación
        function [puerto,e]=duracion(obj,nombre_bd_salida,nombre_bd_entrada)
            base_datos1 = fopen(nombre_bd_salida,'r');
            A = textscan(base_datos1,'%f %f %f %f %f %f %s %d %d %d %d %d %d');
            fclose(base_datos1);
            
            ti=[A{1,1}(length(A{1,1})) A{1,2}(length(A{1,2})) A{1,3}(length(A{1,3})) A{1,4}(length(A{1,4})) A{1,5}(length(A{1,5})) A{1,6}(length(A{1,6}))];
            
            base_datos2 = fopen(nombre_bd_entrada,'r');
            B = textscan(base_datos1,'%f %f %f %f %f %f %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
            fclose(base_datos2);
            tf=[B{1,1}(length(B{1,1})) B{1,2}(length(B{1,2})) B{1,3}(length(B{1,3})) B{1,4}(length(B{1,4})) B{1,5}(length(B{1,5})) B{1,6}(length(B{1,6}))];
            
            e = etime(tf,ti);
            puerto=obj.puerto;
        end
        
        %Función para calcular el tiempo del ciclo de comunicación
        function [puerto,e]=duracion2(obj,nombre_bd_salida,nombre_bd_entrada)
            base_datos1 = fopen(nombre_bd_salida,'r');
            A = textscan(base_datos1,'%f %f %f %f %f %f %s %d %d %d %d %d %d');
            fclose(base_datos1);
            
            ti=[A{1,1}(length(A{1,1})) A{1,2}(length(A{1,2})) A{1,3}(length(A{1,3})) A{1,4}(length(A{1,4})) A{1,5}(length(A{1,5})) A{1,6}(length(A{1,6}))];
            
            base_datos2 = fopen(nombre_bd_entrada,'r');
            B = textscan(base_datos1,'%f %f %f %f %f %f %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
            fclose(base_datos2);
            tf=[B{1,1}(length(B{1,1})) B{1,2}(length(B{1,2})) B{1,3}(length(B{1,3})) B{1,4}(length(B{1,4})) B{1,5}(length(B{1,5})) B{1,6}(length(B{1,6}))];
            
            e = etime(tf,ti);
            puerto=obj.puerto;
        end
        
    end
end
