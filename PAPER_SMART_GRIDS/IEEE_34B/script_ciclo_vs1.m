%% Llamar métodos

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Envío datos de corriente RMS 3F      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Lectura de datos de corriente dados por los P.C.C. de la red eléctrica
rto = get_param('IEEE34BARRAS/EMISOR-RECEPTOR/TCP_IP_TX1/LECTURA', 'RuntimeObject');
datos_simulink=rto.InputPort(1).Data;

if client_1.buffer_out==6
    RE_INT=fix(datos_simulink(1));
    GD1_INT=fix(datos_simulink(2));
    GD2_INT=fix(datos_simulink(3)); 
   
    if RE_INT > 255
        RE_DATO1=255;
        RE_DATO2=RE_INT-255;
    else
        RE_DATO1=0;
        RE_DATO2=RE_INT;
    end
    
    if GD1_INT > 255
        GD1_DATO1=255;
        GD1_DATO2=GD1_INT-255;
    else
        GD1_DATO1=0;
        GD1_DATO2=GD1_INT;
    end
    
    if GD2_INT > 255
        GD2_DATO1=255;
        GD2_DATO2=GD2_INT-255;
    else
        GD2_DATO1=0;
        GD2_DATO2=GD2_INT;
    end
    
    dato6=uint8([RE_DATO1,RE_DATO2,GD1_DATO1,GD1_DATO2,GD2_DATO1,GD2_DATO2]);
    
    client_1.dato_escritura=dato6;
    
    % Operación de escritura de datos hacía el server_1enario_1_art_JA_v6_RE/TCP_IP
    escritura_datos_1(client_1,client_1.dato_escritura)
    % Grabación en BD
    grabar_datos_salida_6(client_1,'BD_datos_salida6.txt')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Recibo configuración dada por la U.C.%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Operación de lectura
if client_1.buffer_in==190
    client_1.dato_lectura=lectura_datos_190(client_1);
    
    if isempty(client_1.dato_lectura) ==0
        [CONF1,K1,ALFA1,B1,PS1,TMS1,TINS1,ESC1,CONF2,K2,ALFA2,B2,PS2,TMS2,TINS2,ESC2,CONF3,K3,ALFA3,B3,PS3,TMS3,TINS3,ESC3,CONF4,K4,ALFA4,B4,PS4,TMS4,TINS4,ESC4,CONF5,K5,ALFA5,B5,PS5,TMS5,TINS5,ESC5]=arreglo_datos_s190_c6(client_1);
        client_1.dato_lectura=[CONF1,K1,ALFA1,B1,PS1,TMS1,TINS1,ESC1,CONF2,K2,ALFA2,B2,PS2,TMS2,TINS2,ESC2,CONF3,K3,ALFA3,B3,PS3,TMS3,TINS3,ESC3,CONF4,K4,ALFA4,B4,PS4,TMS4,TINS4,ESC4,CONF5,K5,ALFA5,B5,PS5,TMS5,TINS5,ESC5,0];             
        % Grabación en BD
        grabar_datos_llegada_190(client_1,'BD_datos_llegada190.txt')
        % Actualización de la configuración enviada en simulink
        [puerto,e]=duracion2(client_1,'BD_datos_salida6.txt','BD_datos_llegada190.txt');
        set_param('IEEE34BARRAS/EMISOR-RECEPTOR/TCP_IP_RX1/ESCRITURA', 'Value', 'client_1.dato_lectura')
        set_param('IEEE34BARRAS/EMISOR-RECEPTOR/TCP_IP_RX1/RETARDO', 'Value', 'e')
    end
end

if client_1.buffer_in==256
    client_1.dato_lectura=lectura_datos_256(client_1);
    
    if isempty(client_1.dato_lectura) ==0
        [CONF1,K1,ALFA1,B1,PS1,TMS1,TINS1,ESC1,CONF2,K2,ALFA2,B2,PS2,TMS2,TINS2,ESC2,CONF3,K3,ALFA3,B3,PS3,TMS3,TINS3,ESC3,CONF4,K4,ALFA4,B4,PS4,TMS4,TINS4,ESC4,CONF5,K5,ALFA5,B5,PS5,TMS5,TINS5,ESC5,ADICIONAL]=arreglo_datos_s256_c6(client_1);
        client_1.dato_lectura=[CONF1,K1,ALFA1,B1,PS1,TMS1,TINS1,ESC1,CONF2,K2,ALFA2,B2,PS2,TMS2,TINS2,ESC2,CONF3,K3,ALFA3,B3,PS3,TMS3,TINS3,ESC3,CONF4,K4,ALFA4,B4,PS4,TMS4,TINS4,ESC4,CONF5,K5,ALFA5,B5,PS5,TMS5,TINS5,ESC5,ADICIONAL];             
        % Grabación en BD
        grabar_datos_llegada_256(client_1,'BD_datos_llegada256.txt')
        % Actualización de la configuración enviada en simulink
        [puerto,e]=duracion2(client_1,'BD_datos_salida6.txt','BD_datos_llegada256.txt');
        set_param('IEEE34BARRAS/EMISOR-RECEPTOR/TCP_IP_RX1/ESCRITURA', 'Value', 'client_1.dato_lectura')
        set_param('IEEE34BARRAS/EMISOR-RECEPTOR/TCP_IP_RX1/RETARDO', 'Value', 'e')
    end
end

if client_1.buffer_in==512
    client_1.dato_lectura=lectura_datos_512(client_1);
    
    if isempty(client_1.dato_lectura) ==0
        [CONF1,K1,ALFA1,B1,PS1,TMS1,TINS1,ESC1,CONF2,K2,ALFA2,B2,PS2,TMS2,TINS2,ESC2,CONF3,K3,ALFA3,B3,PS3,TMS3,TINS3,ESC3,CONF4,K4,ALFA4,B4,PS4,TMS4,TINS4,ESC4,CONF5,K5,ALFA5,B5,PS5,TMS5,TINS5,ESC5,ADICIONAL]=arreglo_datos_s512_c6(client_1);
        client_1.dato_lectura=[CONF1,K1,ALFA1,B1,PS1,TMS1,TINS1,ESC1,CONF2,K2,ALFA2,B2,PS2,TMS2,TINS2,ESC2,CONF3,K3,ALFA3,B3,PS3,TMS3,TINS3,ESC3,CONF4,K4,ALFA4,B4,PS4,TMS4,TINS4,ESC4,CONF5,K5,ALFA5,B5,PS5,TMS5,TINS5,ESC5,ADICIONAL];             
        % Grabación en BD
        grabar_datos_llegada_256(client_1,'BD_datos_llegada512.txt')
        % Actualización de la configuración enviada en simulink
        [puerto,e]=duracion2(client_1,'BD_datos_salida6.txt','BD_datos_llegada512.txt');
        set_param('IEEE34BARRAS/EMISOR-RECEPTOR/TCP_IP_RX1/ESCRITURA', 'Value', 'client_1.dato_lectura')
        set_param('IEEE34BARRAS/EMISOR-RECEPTOR/TCP_IP_RX1/RETARDO', 'Value', 'e')
    end
end

if client_1.buffer_in==1024
    client_1.dato_lectura=lectura_datos_1024(client_1);
    
    if isempty(client_1.dato_lectura) ==0
        [CONF1,K1,ALFA1,B1,PS1,TMS1,TINS1,ESC1,CONF2,K2,ALFA2,B2,PS2,TMS2,TINS2,ESC2,CONF3,K3,ALFA3,B3,PS3,TMS3,TINS3,ESC3,CONF4,K4,ALFA4,B4,PS4,TMS4,TINS4,ESC4,CONF5,K5,ALFA5,B5,PS5,TMS5,TINS5,ESC5,ADICIONAL]=arreglo_datos_s1024_c6(client_1);
        client_1.dato_lectura=[CONF1,K1,ALFA1,B1,PS1,TMS1,TINS1,ESC1,CONF2,K2,ALFA2,B2,PS2,TMS2,TINS2,ESC2,CONF3,K3,ALFA3,B3,PS3,TMS3,TINS3,ESC3,CONF4,K4,ALFA4,B4,PS4,TMS4,TINS4,ESC4,CONF5,K5,ALFA5,B5,PS5,TMS5,TINS5,ESC5,ADICIONAL];             
        % Grabación en BD
        grabar_datos_llegada_256(client_1,'BD_datos_llegada1024.txt')
        % Actualización de la configuración enviada en simulink
        [puerto,e]=duracion2(client_1,'BD_datos_salida6.txt','BD_datos_llegada1024.txt');
        set_param('IEEE34BARRAS/EMISOR-RECEPTOR/TCP_IP_RX1/ESCRITURA', 'Value', 'client_1.dato_lectura')
        set_param('IEEE34BARRAS/EMISOR-RECEPTOR/TCP_IP_RX1/RETARDO', 'Value', 'e')
    end
end

if client_1.buffer_in==2048
    client_1.dato_lectura=lectura_datos_2048(client_1);
    
    if isempty(client_1.dato_lectura) ==0
        [CONF1,K1,ALFA1,B1,PS1,TMS1,TINS1,ESC1,CONF2,K2,ALFA2,B2,PS2,TMS2,TINS2,ESC2,CONF3,K3,ALFA3,B3,PS3,TMS3,TINS3,ESC3,CONF4,K4,ALFA4,B4,PS4,TMS4,TINS4,ESC4,CONF5,K5,ALFA5,B5,PS5,TMS5,TINS5,ESC5,ADICIONAL]=arreglo_datos_s2048_c6(client_1);
        client_1.dato_lectura=[CONF1,K1,ALFA1,B1,PS1,TMS1,TINS1,ESC1,CONF2,K2,ALFA2,B2,PS2,TMS2,TINS2,ESC2,CONF3,K3,ALFA3,B3,PS3,TMS3,TINS3,ESC3,CONF4,K4,ALFA4,B4,PS4,TMS4,TINS4,ESC4,CONF5,K5,ALFA5,B5,PS5,TMS5,TINS5,ESC5,ADICIONAL];             
        % Grabación en BD
        grabar_datos_llegada_256(client_1,'BD_datos_llegada2048.txt')
        % Actualización de la configuración enviada en simulink
        [puerto,e]=duracion2(client_1,'BD_datos_salida6.txt','BD_datos_llegada2048.txt');
        set_param('IEEE34BARRAS/EMISOR-RECEPTOR/TCP_IP_RX1/ESCRITURA', 'Value', 'client_1.dato_lectura')
        set_param('IEEE34BARRAS/EMISOR-RECEPTOR/TCP_IP_RX1/RETARDO', 'Value', 'e')
    end
end

if client_1.buffer_in==4096
    client_1.dato_lectura=lectura_datos_4096(client_1);
    
    if isempty(client_1.dato_lectura) ==0
        [CONF1,K1,ALFA1,B1,PS1,TMS1,TINS1,ESC1,CONF2,K2,ALFA2,B2,PS2,TMS2,TINS2,ESC2,CONF3,K3,ALFA3,B3,PS3,TMS3,TINS3,ESC3,CONF4,K4,ALFA4,B4,PS4,TMS4,TINS4,ESC4,CONF5,K5,ALFA5,B5,PS5,TMS5,TINS5,ESC5,ADICIONAL]=arreglo_datos_s4096_c6(client_1);
        client_1.dato_lectura=[CONF1,K1,ALFA1,B1,PS1,TMS1,TINS1,ESC1,CONF2,K2,ALFA2,B2,PS2,TMS2,TINS2,ESC2,CONF3,K3,ALFA3,B3,PS3,TMS3,TINS3,ESC3,CONF4,K4,ALFA4,B4,PS4,TMS4,TINS4,ESC4,CONF5,K5,ALFA5,B5,PS5,TMS5,TINS5,ESC5,ADICIONAL];             
        % Grabación en BD
        grabar_datos_llegada_256(client_1,'BD_datos_llegada4096.txt')
        % Actualización de la configuración enviada en simulink
        [puerto,e]=duracion2(client_1,'BD_datos_salida6.txt','BD_datos_llegada4096.txt');
        set_param('IEEE34BARRAS/EMISOR-RECEPTOR/TCP_IP_RX1/ESCRITURA', 'Value', 'client_1.dato_lectura')
        set_param('IEEE34BARRAS/EMISOR-RECEPTOR/TCP_IP_RX1/RETARDO', 'Value', 'e')
    end
end