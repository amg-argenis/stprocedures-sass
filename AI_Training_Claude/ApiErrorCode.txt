package com.washtrack.washtrack_api.util.exceptions;

import com.washtrack.washtrack_api.orden.constants.ConstantesOrdenes;
import org.springframework.http.HttpStatus;

public enum ApiErrorCode {
  
  // 200
  OPERACION_EXITOSA(HttpStatus.OK, ConstantesOrdenes.OPERACION_EXITOSA),
  
  // 204
  SIN_INFORMACION_EN_BD(HttpStatus.NO_CONTENT, ConstantesOrdenes.DATOS_INVALIDOS),
  
  // 400
  DATOS_INVALIDOS(HttpStatus.BAD_REQUEST, ConstantesOrdenes.DATOS_INVALIDOS),
  
  // 404
  RECURSO_NO_ENCONTRADO(HttpStatus.NOT_FOUND, ConstantesOrdenes.SIN_REGISTROS),
  
  // 409
  CONFLICTO_INTEGRIDAD(HttpStatus.CONFLICT, ConstantesOrdenes.ERROR_BD_INTEGRIDAD),
  
  // 503
  BASE_DATOS_NO_DISPONIBLE(HttpStatus.SERVICE_UNAVAILABLE, ConstantesOrdenes.ERROR_BD_UNAVAILABLE),
  
  // 500, mensaje Error en BD
  ERROR_BASE_DATOS(HttpStatus.INTERNAL_SERVER_ERROR, ConstantesOrdenes.ERROR_BD),
  
  // Error interno, 500, mensaje Server
  ERROR_INTERNO(HttpStatus.INTERNAL_SERVER_ERROR, ConstantesOrdenes.ERROR_SERVER);
  
  private final HttpStatus httpStatus;
  private final String message;
  
  ApiErrorCode(HttpStatus httpStatus, String message) {
    this.httpStatus = httpStatus;
    this.message = message;
  }
  
  public HttpStatus getHttpStatus() {
    return httpStatus;
  }
  
  public String getMessage() {
    return message;
  }
}
