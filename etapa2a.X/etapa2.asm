;====================================================================
; PROYECTO: TP2 - ETAPA 2 (Contador Binario 0 - 255)
; MICROCONTROLADOR: PIC16F887 | OSCILADOR: XT (4 MHz)
; SALIDAS: PORTD (RD0 - RD7)
;====================================================================
    list P=16f887 
    #include "p16f887.inc"    

;------------------------- BITS DE CONFIGURACIÓN -------------------------
    __CONFIG _CONFIG1, _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _LVP_OFF 
    __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF    
    
;====================================================================
; VARIABLES EN RAM - ETAPA 2
;====================================================================
    CBLOCK 0x20
        CONTADOR1
        CONTADOR2
        CONTADOR3
        VALOR_CUENTA            ; Variable que almacena el valor 0 a 255
    ENDC

;====================================================================
; VECTOR DE RESET
;====================================================================
    ORG     0x00
    GOTO    INICIO_E2

;====================================================================
; CONFIGURACIÓN DE PUERTOS
;====================================================================
    ORG     0x05
INICIO_E2
    ; 1. Configurar pines como digitales (Banco 3)
    BSF     STATUS, RP0
    BSF     STATUS, RP1
    CLRF    ANSEL
    CLRF    ANSELH

    ; 2. Configurar todo PORTD como salida (Banco 1)
    BCF     STATUS, RP1
    CLRF    TRISD               ; RD0 a RD7 como salidas digitales

    ; 3. Banco 0 para operar
    BCF     STATUS, RP0
    CLRF    PORTD               ; Limpia el puerto D
    CLRF    VALOR_CUENTA        ; Inicializa la cuenta en 0

;====================================================================
; BUCLE PRINCIPAL (INCREMENTO BINARIO)
;====================================================================
BUCLE_CONTADOR
    MOVF    VALOR_CUENTA, W
    MOVWF   PORTD               ; Presenta el valor binario en los 8 LEDs
    CALL    DELAY         ; Pausa entre cada incremento (~250 ms)
    INCF    VALOR_CUENTA, F     ; Incrementa valor (al pasar 255 vuelve a 0 automáticamente)
    GOTO    BUCLE_CONTADOR

;====================================================================
; SUBRUTINA DE RETARDO (Misma estructura que Etapa 1)
;====================================================================
DELAY
    MOVLW   0xFF
    MOVWF   CONTADOR1
    MOVWF   CONTADOR2
    MOVLW   0x02                
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