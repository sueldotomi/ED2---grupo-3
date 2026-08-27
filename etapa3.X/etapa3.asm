;====================================================================
; PROYECTO: TP2 - ETAPA 3 (Secuencia de Luces Bidireccional)
; MICROCONTROLADOR: PIC16F887 | OSCILADOR: XT (4 MHz)
; SALIDAS: PORTD (RD0 - RD7)
;====================================================================
    list P=16f887 
    #include "p16f887.inc"    

;------------------------- BITS DE CONFIGURACIÓN -------------------------
    __CONFIG _CONFIG1, _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _LVP_OFF 
    __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF    
    
;====================================================================
; VARIABLES EN RAM - ETAPA 3
;====================================================================
    CBLOCK 0x20
        CONTADOR1
        CONTADOR2
        CONTADOR3
        CANTIDAD_DESPLAZAMIENTOS ; Controla la cantidad de pasos de rotación
    ENDC

;====================================================================
; VECTOR DE RESET
;====================================================================
    ORG     0x00
    GOTO    INICIO_E3

;====================================================================
; CONFIGURACIÓN DE PUERTOS
;====================================================================
    ORG     0x05
INICIO_E3
    ; 1. Configurar pines como digitales (Banco 3)
    BSF     STATUS, RP0
    BSF     STATUS, RP1
    CLRF    ANSEL
    CLRF    ANSELH

    ; 2. Configurar todo PORTD como salida (Banco 1)
    BCF     STATUS, RP1
    CLRF    TRISD               ; RD0 a RD7 como salidas

    ; 3. Banco 0 para operar
    BCF     STATUS, RP0
    CLRF    PORTD

;====================================================================
; BUCLE PRINCIPAL (BARRIDO BIDIRECCIONAL)
;====================================================================
BUCLE_SECUENCIA
    ; --- Desplazamiento Izquierda (RD0 -> RD7) ---
    BCF     STATUS, C
    MOVLW   b'00000001'         ; Enciende únicamente RD0
    MOVWF   PORTD
    MOVLW   .7
    MOVWF   CANTIDAD_DESPLAZAMIENTOS

ROTA_IZQ
    CALL    DELAY
    BCF     STATUS, C           ; Asegura que el Carry no ingrese un 1
    RLF     PORTD, F            ; Rota hacia la izquierda
    DECFSZ  CANTIDAD_DESPLAZAMIENTOS, F
    GOTO    ROTA_IZQ

    ; --- Desplazamiento Derecha (RD7 -> RD0) ---
    MOVLW   .7
    MOVWF   CANTIDAD_DESPLAZAMIENTOS

ROTA_DER
    CALL    DELAY
    BCF     STATUS, C           ; Asegura que el Carry no ingrese un 1
    RRF     PORTD, F            ; Rota hacia la derecha
    DECFSZ  CANTIDAD_DESPLAZAMIENTOS, F
    GOTO    ROTA_DER

    GOTO    BUCLE_SECUENCIA     ; Repite el juego de luces continuamente

;====================================================================
; SUBRUTINA DE RETARDO 
;====================================================================
DELAY
    MOVLW   0xFF
    MOVWF   CONTADOR1
    MOVWF   CONTADOR2
    MOVLW   0x01                
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