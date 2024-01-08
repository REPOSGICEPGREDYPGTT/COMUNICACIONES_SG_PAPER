/** @file sys_main.c
*   @brief Application main file
*   @date 15.July.2009
*   @version 1.01.000
*
*   This file contains the initialization & control path for the LwIP & EMAC driver
*   and can be called from system main.
*/

/* (c) Texas Instruments 2011, All rights reserved. */

// Editado con funciones de echo_tcp_ip.
// El código fuente de echo_tcp_ip está en http://cvs.savannah.gnu.org/viewvc/lwip/contrib/apps/tcpecho_raw/

/*
** Interrupt Handler for Core 0 Receive interrupt
*/
/*
** lwIP Compile Time Options for HDK.
*/
#include "lwiplib.h"
#include "HL_sci.h"
#include "lwip\inet.h"
#include "locator.h"
#include "lwip/debug.h"
#include "lwip/stats.h"
#include "lwip/tcp.h"
#include<stdio.h>

/* Seleccionando el modulo SCI */
#define sciREGx  sciREG1

uint8_t    txtCRLF[]         = {'\r', '\n'};
uint8_t    txtTitle[]        = {"BIENVENIDO - CONEXION: CCL/TI <-> MATLAB/SIMULINK"};
uint8_t    txtTI[]           = {"Texas Instruments"};
uint8_t    txtLittleEndian[] = {"Dispositivo Little Endian"};
uint8_t    txtEnetInit[]     = {"Inicializando Ethernet (DHCP)"};
uint8_t    txtErrorInit[]    = {"-------- ERROR INICIALIZANDO HARDWARE --------"};
uint8_t    txtIPAddrTxt[]    = {"Direccion IP del dispositivo: "};
uint8_t    * txtIPAddrItoA;

volatile int countEMACCore0RxIsr = 0;
#pragma INTERRUPT(EMACCore0RxIsr, IRQ)

void EMACCore0RxIsr(void)
{
   countEMACCore0RxIsr++;
   lwIPRxIntHandler(0);
}
/*
** Interrupt Handler for Core 0 Transmit interrupt
*/
volatile int countEMACCore0TxIsr = 0;
#pragma INTERRUPT(EMACCore0TxIsr, IRQ)

void EMACCore0TxIsr(void)
{
 countEMACCore0TxIsr++;
   lwIPTxIntHandler(0);
}

void IntMasterIRQEnable(void)
{
 _enable_IRQ();
 return;
}

void IntMasterIRQDisable(void)
{
 _disable_IRQ();
 return;
}

unsigned int IntMasterStatusGet(void)
{
   return (0xC0 & _get_CPSR());
}

void sciDisplayText(sciBASE_t *sci, uint8_t *text,uint32_t length)
{
   while(length--)
   {
       while ((sci->FLR & 0x4) == 4); /* wait until busy */
       sciSendByte(sci,*text++);      /* send out text   */
   };
}

// sci notification (Not used but must be provided)
void sciNotification(sciBASE_t *sci, uint32_t flags)
{
    return;
}

void smallDelay(void) {
      static volatile unsigned int delayval;
      delayval = 10000;   // 100000 are about 10ms
      while(delayval--);
}

static struct tcp_pcb *ccl_pcb;

enum ccl_states
{
  ES_NONE = 0,
  ES_ACCEPTED,
  ES_RECEIVED,
  ES_CLOSING
};

struct ccl_state
{
  u8_t state;
  u8_t retries;
  struct tcp_pcb *pcb;
  struct pbuf *p; // pbuf(chain) to recycle
  uint8_t *ensayo;
};

err_t ccl_accept(void *arg, struct tcp_pcb *newpcb, err_t err);
err_t ccl_recv(void *arg, struct tcp_pcb *tpcb, struct pbuf *p, err_t err);
void ccl_error(void *arg, err_t err);
void ccl_close(struct tcp_pcb *tpcb, struct ccl_state *es);
void ccl_send(struct tcp_pcb *tpcb, struct ccl_state *es);

///////////////////////////////////////////////////////////////////////////
//                                                                       //
///////////////////////////////////////////////////////////////////////////

err_t ccl_accept(void *arg, struct tcp_pcb *newpcb, err_t err)
{
  //Disponible en err.h
  err_t ret_err;

  struct ccl_state *es; //Declara un puntero es a un tipo de estructura ccl_state

  LWIP_UNUSED_ARG(arg); //no usa arg de la funcion accept
  LWIP_UNUSED_ARG(err); //no usar err de la funcion accept

  /* commonly observed practive to call tcp_setprio(), why? */

  tcp_setprio(newpcb, TCP_PRIO_MIN);
  es = (struct ccl_state *)mem_malloc(sizeof(struct ccl_state));

  if (es != NULL)
  {
    es->state = ES_ACCEPTED;
    es->pcb = newpcb;
    es->retries = 0; //reintentos
    es->p = NULL;

    // pass newly allocated es to our callbacks
    // pasar "es" recién asignado a nuestras devoluciones de llamada

    tcp_arg(newpcb, es);
    tcp_recv(newpcb, ccl_recv);
    tcp_err(newpcb, ccl_error);

    ret_err = ERR_OK;
  }
  else
  {
    ret_err = ERR_MEM;
  }
  return ret_err;
}

err_t ccl_recv(void *arg, struct tcp_pcb *tpcb, struct pbuf *p, err_t err)
{
  struct ccl_state *es;
  err_t ret_err;

  LWIP_ASSERT("arg != NULL",arg != NULL);

  es = (struct ccl_state *)arg;

  if (p == NULL)
  {
    /* remote host closed connection */
    es->state = ES_CLOSING;

    if(es->p == NULL)
    {
       // we're done sending, close it
       // Hemos terminado de enviar, ciérralo

       ccl_close(tpcb, es);

       sciDisplayText(sciREGx, txtCRLF, sizeof(txtCRLF));
       sciDisplayText(sciREGx, (uint8_t*)"ESTADO CONEXION: CERRADA", sizeof("ESTADO CONEXION: CERRADA"));
       sciDisplayText(sciREGx, txtCRLF, sizeof(txtCRLF));
    }
    else
    {
      // we're not done yet
      // No hemos terminado todavía
      sciDisplayText(sciREGx, txtCRLF, sizeof(txtCRLF));
      sciDisplayText(sciREGx, (uint8_t*)"NO HAY P NULL", sizeof("NO HAY P NULL"));
      sciDisplayText(sciREGx, txtCRLF, sizeof(txtCRLF));
    }
    ret_err = ERR_OK;
    sciDisplayText(sciREGx, txtCRLF, sizeof(txtCRLF));
    sciDisplayText(sciREGx, (uint8_t*)"ESTADO CONEXION: P NULL", sizeof("ESTADO CONEXION: P NULL"));
    sciDisplayText(sciREGx, txtCRLF, sizeof(txtCRLF));
  }

  else if(err != ERR_OK)
  {
    /* cleanup, for unkown reason */
    if (p != NULL)
    {
        es->p = NULL;
        pbuf_free(p);
    }
    ret_err = err;

    sciDisplayText(sciREGx, txtCRLF, sizeof(txtCRLF));
    sciDisplayText(sciREGx, (uint8_t*)"P ERROR", sizeof("P ERROR"));
    sciDisplayText(sciREGx, txtCRLF, sizeof(txtCRLF));
  }

  else if(es->state == ES_ACCEPTED)
  {
    // first data chunk in p->payload
    es->state = ES_RECEIVED;

    // store reference to incoming pbuf (chain)
    // Almacenar referencia para el pbuf entrante (cadena)
    es->p = p;
    uint8_t *pData;
    pData = p->payload;

    //CONFIGURACIÓN PARA CCL RED 3 - IEEE 34 BARRAS

    uint32_t RMS_RE_DATO1;
    uint32_t RMS_RE_DATO2;
    uint32_t RMS_GD1_DATO1;
    uint32_t RMS_GD1_DATO2;
    uint32_t RMS_GD2_DATO1;
    uint32_t RMS_GD2_DATO2;
    uint32_t RMS_RE;
    uint32_t RMS_GD1;
    uint32_t RMS_GD2;

    RMS_RE_DATO1 = *(pData); //Acceso a cada byte
    RMS_RE_DATO2 = *(pData+1); //Acceso a cada byte
    RMS_GD1_DATO1 = *(pData+2); //Acceso a cada byte
    RMS_GD1_DATO2 = *(pData+3); //Acceso a cada byte
    RMS_GD2_DATO1 = *(pData+4); //Acceso a cada byte
    RMS_GD2_DATO2 = *(pData+5); //Acceso a cada byte

    RMS_RE=RMS_RE_DATO1+RMS_RE_DATO2;
    RMS_GD1=RMS_GD1_DATO1+RMS_GD1_DATO2;
    RMS_GD2=RMS_GD2_DATO1+RMS_GD2_DATO2;

    //Logica del CCL
    uint8_t *y;

    //Red radial:
    if(RMS_RE>=1 && (RMS_GD1<1 && RMS_GD2<1)){
        uint8_t x[] ={"1000000000000000000,1,0.14,0.02,0,1.25,0.0075,0.01,1.4,1,0.14,0.02,0,1,0.015,0.01,3,1,0.14,0.02,0,0.53,0.011,0.01,8,1,0.14,0.02,0,2,0.5,10,100,1,0.14,0.02,0,2,0.5,10,100,"};
        y=x;
        }

    //Red con GD:
    if(RMS_RE<1 && (RMS_GD1>=1 || RMS_GD2>=1)){
        uint8_t x[] ={"200000000,2,0.14,0.02,0,1.25,0.0075,0.01,1.4,2,0.14,0.02,0,1.25,0.02,0.01,3,2,0.14,0.02,0,0.81,0.016,0.01,8,2,0.14,0.02,0,1.2,0.015,0.01,6,2,0.14,0.02,0,1.7,0.005,0.01,3,"};
        y=x;
        }

    //Red con GD:
    if(RMS_RE>=1 && (RMS_GD1>=1 || RMS_GD2>=1)){
        uint8_t x[] ={"200000000,2,0.14,0.02,0,1.25,0.0075,0.01,1.4,2,0.14,0.02,0,1.25,0.02,0.01,3,2,0.14,0.02,0,0.81,0.016,0.01,8,2,0.14,0.02,0,1.2,0.015,0.01,6,2,0.14,0.02,0,1.7,0.005,0.01,3,"};
        y=x;
        }

    //Por defecto:
    if(RMS_RE<1 && (RMS_GD1<1 || RMS_GD2<1)){
        uint8_t x[] ={"200000000,2,0.14,0.02,0,1.25,0.0075,0.01,1.4,2,0.14,0.02,0,1.25,0.02,0.01,3,2,0.14,0.02,0,0.81,0.016,0.01,8,2,0.14,0.02,0,1.2,0.015,0.01,6,2,0.14,0.02,0,1.7,0.005,0.01,3,"};
        y=x;
        }

    es->ensayo=y;
    ccl_send(tpcb, es);

    ret_err = ERR_OK;
  }

  else if (es->state == ES_RECEIVED)
  {
      // read some more data
      // Lee más datos
      es->p = p;
      uint8_t *pData;
      pData = p->payload;

      //CONFIGURACIÓN PARA CCL RED 3 - IEEE 34 BARRAS

      uint32_t RMS_RE_DATO1;
      uint32_t RMS_RE_DATO2;
      uint32_t RMS_GD1_DATO1;
      uint32_t RMS_GD1_DATO2;
      uint32_t RMS_GD2_DATO1;
      uint32_t RMS_GD2_DATO2;
      uint32_t RMS_RE;
      uint32_t RMS_GD1;
      uint32_t RMS_GD2;

      RMS_RE_DATO1 = *(pData); //Acceso a cada byte
      RMS_RE_DATO2 = *(pData+1); //Acceso a cada byte
      RMS_GD1_DATO1 = *(pData+2); //Acceso a cada byte
      RMS_GD1_DATO2 = *(pData+3); //Acceso a cada byte
      RMS_GD2_DATO1 = *(pData+4); //Acceso a cada byte
      RMS_GD2_DATO2 = *(pData+5); //Acceso a cada byte

      RMS_RE=RMS_RE_DATO1+RMS_RE_DATO2;
      RMS_GD1=RMS_GD1_DATO1+RMS_GD1_DATO2;
      RMS_GD2=RMS_GD2_DATO1+RMS_GD2_DATO2;

      //Logica del CCL
      uint8_t *y;

      //Red radial:
      if(RMS_RE>=1 && (RMS_GD1<1 && RMS_GD2<1)){
          uint8_t x[] ={"1000000000000000000,1,0.14,0.02,0,1.25,0.0075,0.01,1.4,1,0.14,0.02,0,1,0.015,0.01,3,1,0.14,0.02,0,0.53,0.011,0.01,8,1,0.14,0.02,0,2,0.5,10,100,1,0.14,0.02,0,2,0.5,10,100,"};
          y=x;
          }

      //Red con GD:
      if(RMS_RE<1 && (RMS_GD1>=1 || RMS_GD2>=1)){
          uint8_t x[] ={"200000000,2,0.14,0.02,0,1.25,0.0075,0.01,1.4,2,0.14,0.02,0,1.25,0.02,0.01,3,2,0.14,0.02,0,0.81,0.016,0.01,8,2,0.14,0.02,0,1.2,0.015,0.01,6,2,0.14,0.02,0,1.7,0.005,0.01,3,"};
          y=x;
          }

      //Red con GD:
      if(RMS_RE>=1 && (RMS_GD1>=1 || RMS_GD2>=1)){
          uint8_t x[] ={"200000000,2,0.14,0.02,0,1.25,0.0075,0.01,1.4,2,0.14,0.02,0,1.25,0.02,0.01,3,2,0.14,0.02,0,0.81,0.016,0.01,8,2,0.14,0.02,0,1.2,0.015,0.01,6,2,0.14,0.02,0,1.7,0.005,0.01,3,"};
          y=x;
          }

      //Por defecto:
      if(RMS_RE<1 && (RMS_GD1<1 || RMS_GD2<1)){
          uint8_t x[] ={"200000000,2,0.14,0.02,0,1.25,0.0075,0.01,1.4,2,0.14,0.02,0,1.25,0.02,0.01,3,2,0.14,0.02,0,0.81,0.016,0.01,8,2,0.14,0.02,0,1.2,0.015,0.01,6,2,0.14,0.02,0,1.7,0.005,0.01,3,"};
          y=x;
          }

      es->ensayo=y;
      ccl_send(tpcb, es);
      pbuf_free(p);

      ret_err = ERR_OK;


  }

  else if(es->state == ES_CLOSING)
  {
    // odd case, remote side closing twice, trash data
    // caso extraño, cierre remoto dos veces, datos de basura

    tcp_recved(tpcb, p->tot_len);
    es->p = NULL;
    pbuf_free(p);
    ret_err = ERR_OK;
  }

  else
  {
    // unkown es->state, trash data (datos basura)
    tcp_recved(tpcb, p->tot_len);
    es->p = NULL;
    pbuf_free(p);
    ret_err = ERR_OK;
  }
  return ret_err;
}

void ccl_error(void *arg, err_t err)

{
  struct ccl_state *es;

  LWIP_UNUSED_ARG(err);

  es = (struct ccl_state *)arg;
  if (es != NULL)
  {
    mem_free(es);
  }
}

void ccl_close(struct tcp_pcb *tpcb, struct ccl_state *es)
{
  tcp_arg(tpcb, NULL);
  tcp_sent(tpcb, NULL);
  tcp_recv(tpcb, NULL);
  tcp_err(tpcb, NULL);
  tcp_poll(tpcb, NULL, 0);

  if (es != NULL)
  {
    mem_free(es);
  }
  tcp_close(tpcb);
}

void ccl_send(struct tcp_pcb *tpcb, struct ccl_state *es)
{
  err_t wr_err = ERR_OK;

  if ((wr_err == ERR_OK) &&
         (es->ensayo != NULL) &&
         ((sizeof(es->ensayo)) <= tcp_sndbuf(tpcb))) // ((pcb)->snd_buf)
  {
  wr_err = tcp_write(tpcb, es->ensayo, 170, 1);
  tcp_output(tpcb);

  //tcp_arg(tpcb, NULL);
  //tcp_err(tpcb, NULL);
  //tcp_poll(tpcb, NULL, 0);
  //tcp_sent(tpcb, NULL);
  //tcp_recv(tpcb, NULL);
  mem_free(es);
  }
}

void local_center_init(void)
{
  //Creamos un nuevo bloque de control de protocolo TCP
  ccl_pcb = tcp_new();

  sciDisplayText(sciREGx, txtCRLF, sizeof(txtCRLF));
  sciDisplayText(sciREGx, (uint8_t*)"ESTADO CONEXION: PCB PARA EL CCL CREADO", sizeof("ESTADO CONEXION: PCB PARA EL CCL CREADO"));
  sciDisplayText(sciREGx, txtCRLF, sizeof(txtCRLF));

  if (ccl_pcb != NULL)
  {
    err_t err;

    struct ip_addr remota;
    IP4_ADDR(&remota,0,0,0,0);
    err = tcp_bind(ccl_pcb,&remota,200);

    //Si el PCB está ligado a un puerto y dirección IP remoto entonces:

    if (err == ERR_OK)
    {
      ccl_pcb = tcp_listen(ccl_pcb);

      sciDisplayText(sciREGx, txtCRLF, sizeof(txtCRLF));
      sciDisplayText(sciREGx, (uint8_t*)"ESTADO CONEXION: PUERTO ESTA ESCUCHANDO", sizeof("ESTADO CONEXION: PUERTO ESTA ESCUCHANDO"));
      sciDisplayText(sciREGx, txtCRLF, sizeof(txtCRLF));

      tcp_accept(ccl_pcb, ccl_accept);
    }
    else
    {
      /* abort? output diagnostic? */
    }
  }
  else
  {
    /* abort? output diagnostic? */
  }
}

void EMAC_LwIP_Main (uint8_t * macAddress)
{
   unsigned int   ipAddr;
   struct in_addr devIPAddress;

   sciInit();

 // Enable the interrupt generation in CPSR register
 IntMasterIRQEnable();
 _enable_FIQ();

 // Initialze the lwIP library, using DHCP
 sciDisplayText(sciREGx, txtEnetInit, sizeof(txtEnetInit));

 ipAddr = lwIPInit(0, macAddress, 0, 0, 0, IPADDR_USE_DHCP);

 sciDisplayText(sciREGx, (uint8_t*)"..ESPERE", sizeof("..ESPERE"));
 sciDisplayText(sciREGx, txtCRLF, sizeof(txtCRLF));

 if (0 == ipAddr) {
   sciDisplayText(sciREGx, txtCRLF, sizeof(txtCRLF));
   sciDisplayText(sciREGx, txtCRLF, sizeof(txtCRLF));
   sciDisplayText(sciREGx, txtErrorInit, sizeof(txtErrorInit));
   sciDisplayText(sciREGx, txtCRLF, sizeof(txtCRLF));
   sciDisplayText(sciREGx, txtCRLF, sizeof(txtCRLF));
 } else {
   /* Convert IP Address to string */
   devIPAddress.s_addr = ipAddr;
   txtIPAddrItoA = (uint8_t *)inet_ntoa(devIPAddress);

   sciDisplayText(sciREGx, txtCRLF, sizeof(txtCRLF));
   sciDisplayText(sciREGx, txtCRLF, sizeof(txtCRLF));

   sciDisplayText(sciREGx, txtTitle, sizeof(txtTitle));
   sciDisplayText(sciREGx, txtCRLF, sizeof(txtCRLF));

   sciDisplayText(sciREGx, txtTI, sizeof(txtTI));
   sciDisplayText(sciREGx, txtCRLF, sizeof(txtCRLF));

   sciDisplayText(sciREGx, txtLittleEndian, sizeof(txtLittleEndian));
   sciDisplayText(sciREGx, txtCRLF, sizeof(txtCRLF));

   sciDisplayText(sciREGx, txtIPAddrTxt, sizeof(txtIPAddrTxt));
   sciDisplayText(sciREGx, txtIPAddrItoA, 16);
   sciDisplayText(sciREGx, txtCRLF, sizeof(txtCRLF));

   local_center_init();

while (1) {}
 }
}
