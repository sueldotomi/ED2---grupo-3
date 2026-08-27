;====================================================================

; PROYECTO: TP2 - Contador Binario y Secuencia de LEDs

; MICROCONTROLADOR: PIC16F887 | OSCILADOR: XT (4 MHz)

; PUERTOS: PORTD (Salidas LEDs 0-7), RC0 (Entrada Pulsador)

;====================================================================

list P=16f887 

#include "p16f887.inc"    

;---------------------------bits de configuración------------------------------
__CONFIG _CONFIG1, _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _LVP_OFF 
__CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF    
;====================================================================

; ETAPA 1: Blinking LED (Prueba de Hardware)

;===================================================================
    
; --- VARIABLES EN RAM ---
CONTADOR1   EQU     0x20
CONTADOR2   EQU     0x21
CONTADOR3   EQU     0x22

; --- VECTOR DE RESET ---
    ORG     0x00
    GOTO    _INICIO

; --- CONFIGURACIÓN DE PUERTOS ---
    ORG     0x05

_INICIO

    ; 1. Configurar pines como digitales (Banco 3)
    BSF     STATUS, RP0
    BSF     STATUS, RP1
    CLRF    ANSEL
    CLRF    ANSELH

    ; 2. Configurar RD0 como salida (Banco 1)
    BCF     STATUS, RP1
    BCF     TRISD, 0            ; RD0 como salida

    ; 3. Ir a Banco 0 para operar
    BCF     STATUS, RP0
    BCF     PORTD, 0            ; Arranca apagado



; --- BUCLE PRINCIPAL (PARPADEO) ---

BUCLE_BLINK

    BSF     PORTD, 0            ; Enciende el LED en RD0
    CALL    DELAY               ; Espera encendido
    BCF     PORTD, 0            ; Apaga el LED en RD0
    CALL    DELAY               ; Espera apagado
    GOTO    BUCLE_BLINK         ; Repite el ciclo

; --- SUBRUTINA DE RETARDO (~300 ms a 4 MHz) ---

DELAY

    MOVLW   0xFF
    MOVWF   CONTADOR1
    MOVWF   CONTADOR2
    MOVLW   0x02                ; Valor para ajustar el tiempo
    MOVWF   CONTADOR3

RETARDO1
    DECFSZ  CONTADOR1, 1
    GOTO    RETARDO1
    MOVLW   0xFF
    MOVWF   CONTADOR1

RETARDO2
    DECFSZ  CONTADOR2, 1
    GOTO    RETARDO1
    MOVLW   0xFF
    MOVWF   CONTADOR2



RETARDO3
    DECFSZ  CONTADOR3, 1
    GOTO    RETARDO1
    RETURN



    END    