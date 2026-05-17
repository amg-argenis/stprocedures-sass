package com.washtrack.washtrack_api.proceso.controller;

import com.washtrack.washtrack_api.proceso.dto.ProcesoUpdateRequest;
import com.washtrack.washtrack_api.proceso.dto.ProcesosRequest;
import com.washtrack.washtrack_api.proceso.service.IProcesosService;
import com.washtrack.washtrack_api.util.constantes.ConstantesNumericas;
import com.washtrack.washtrack_api.util.exceptions.ApiErrorCode;
import com.washtrack.washtrack_api.util.response.ServiceResult;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.extern.slf4j.Slf4j;
import org.hibernate.validator.constraints.Length;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@Validated
@CrossOrigin
@RequestMapping("${base.path}")
@RestController
public class ProcesosController {
  private final IProcesosService procesosService;
  
  public ProcesosController(IProcesosService procesosService) {
    this.procesosService = procesosService;
  }
  
  // Recuperar tenantId por token
  private String obtenerTenantId(HttpServletRequest httpRequest) {
    return (String) httpRequest.getAttribute("tenantId");
  }
  
  @PostMapping("/procesos/insertar")
  public ResponseEntity<ServiceResult<Object>> insertarProcesoController(
      @Valid @RequestBody ProcesosRequest procesosRequest,
      HttpServletRequest httpRequest) {
    
    log.info("[Iniciando insertar el proceso de lavado | Controller]");
    
    ServiceResult<Object> resultado;
    ResponseEntity<ServiceResult<Object>> response;
    
    try {
      
      String tenantId = obtenerTenantId(httpRequest);
      procesosRequest.setTenantid(tenantId);
      
      resultado = this.procesosService.insertarProcesoService(procesosRequest);
      
      if ( resultado == null ) {
        resultado = new ServiceResult<>(false,
            "Error interno, no se pudo insertar el proceso de lavado",
            ConstantesNumericas.CERO, null);
        response = ResponseEntity.status(ApiErrorCode.ERROR_INTERNO.getHttpStatus()).body(resultado);
      }
      else if ( !resultado.isSuccess() && resultado.getData() instanceof ApiErrorCode ) {
        ApiErrorCode error = (ApiErrorCode) resultado.getData();
        response = ResponseEntity.status(error.getHttpStatus()).body(resultado);
      }
      else {
        response = ResponseEntity.ok(resultado);
      }
      
    }
    catch ( Exception e ) {
      log.error("[Exception | Error critico al insertar el proceso de lavado | Controller | Detalles: {}]",
          e.getMessage(), e);
      response = new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
    
    return response;
    
  }
  
  @PostMapping("/procesos/actualizar")
  public ResponseEntity<ServiceResult<Object>> actualizarProcesoController(
      @Valid @RequestBody ProcesoUpdateRequest procesosRequest,
      HttpServletRequest httpRequest) {
    
    log.info("[Iniciando actualizar el proceso de lavado | Controller]");
    
    ServiceResult<Object> resultado;
    ResponseEntity<ServiceResult<Object>> response;
    
    try {
      
      String tenantId = obtenerTenantId(httpRequest);
      procesosRequest.setTenantid(tenantId);
      
      resultado = this.procesosService.actualizarProcesoService(procesosRequest);
      
      if ( resultado == null ) {
        resultado = new ServiceResult<>(false,
            "Error interno, no se pudo actualizar el proceso de lavado",
            ConstantesNumericas.CERO, null);
        response = ResponseEntity.status(ApiErrorCode.ERROR_INTERNO.getHttpStatus()).body(resultado);
      }
      else if ( !resultado.isSuccess() && resultado.getData() instanceof ApiErrorCode ) {
        ApiErrorCode error = (ApiErrorCode) resultado.getData();
        response = ResponseEntity.status(error.getHttpStatus()).body(resultado);
      }
      else {
        response = ResponseEntity.ok(resultado);
      }
      
    }
    catch ( Exception e ) {
      log.error("[Exception | Error critico al actualizar el proceso de lavado | Controller | Detalles: {}]",
          e.getMessage(), e);
      response = new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
    
    return response;
    
  }
  
  @PostMapping("/procesos/eliminar/procesoRequest")
  public ResponseEntity<ServiceResult<Object>> eliminarProcesoController(
      @RequestParam
      @NotNull(message = "Debe proporcionar el Id del proceso")
      @Length(min = 10, max = 36, message = "El numero de caracteres es invalido al permitido para el Id")
      String procesoRequest,
      HttpServletRequest httpRequest) {
    
    log.info("[Iniciando actualizar el proceso de lavado | Controller]");
    
    ServiceResult<Object> resultado;
    ResponseEntity<ServiceResult<Object>> response;
    
    try {
      
      String tenantId = obtenerTenantId(httpRequest);
      
      resultado = this.procesosService.eliminarProcesoService(procesoRequest, tenantId);
      
      if ( resultado == null ) {
        resultado = new ServiceResult<>(false,
            "Error interno, no se pudo eliminar el proceso de lavado",
            ConstantesNumericas.CERO, null);
        response = ResponseEntity.status(ApiErrorCode.ERROR_INTERNO.getHttpStatus()).body(resultado);
      }
      else if ( !resultado.isSuccess() && resultado.getData() instanceof ApiErrorCode ) {
        ApiErrorCode error = (ApiErrorCode) resultado.getData();
        response = ResponseEntity.status(error.getHttpStatus()).body(resultado);
      }
      else {
        response = ResponseEntity.ok(resultado);
      }
      
    }
    catch ( Exception e ) {
      log.error("[Exception | Error critico al eliminar el proceso de lavado | Controller | Detalles: {}]",
          e.getMessage(), e);
      response = new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
    
    return response;
    
  }
  
  @GetMapping("/procesos/busquedas/buscar")
  public ResponseEntity<ServiceResult<Object>> buscarProcesoController(
      @RequestParam
      @NotNull(message = "Debe proporcionar el codigo del proceso de lavado")
      @Length(min = 1, max = 10, message = "El numero de caracteres es invalido al permitido para el codigo")
      String procesoRequest,
      HttpServletRequest httpRequest) {
    
    log.info("[Iniciando buscar el proceso de lavado | Controller]");
    
    ServiceResult<Object> resultado;
    ResponseEntity<ServiceResult<Object>> response;
    
    try {
      
      String tenantId = obtenerTenantId(httpRequest);
      
      resultado = this.procesosService.buscarProcesoService(procesoRequest, tenantId);
      
      if ( resultado == null ) {
        resultado = new ServiceResult<>(false,
            "Error interno, no se pudo recuperar el proceso de lavado",
            ConstantesNumericas.CERO, null);
        response = ResponseEntity.status(ApiErrorCode.ERROR_INTERNO.getHttpStatus()).body(resultado);
      }
      else if ( !resultado.isSuccess() && resultado.getData() instanceof ApiErrorCode ) {
        ApiErrorCode error = (ApiErrorCode) resultado.getData();
        response = ResponseEntity.status(error.getHttpStatus()).body(resultado);
      }
      else {
        response = ResponseEntity.ok(resultado);
      }
      
    }
    catch ( Exception e ) {
      log.error("[Exception | Error critico al recuperar el proceso de lavado | Controller | Detalles: {}]",
          e.getMessage(), e);
      response = new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
    
    return response;
    
  }
  
  @GetMapping("/procesos/listar")
  public ResponseEntity<ServiceResult<Object>> listarProcesoController(HttpServletRequest httpRequest) {
    
    log.info("[Iniciando listar procesos de lavado | Controller]");
    
    ServiceResult<Object> resultado;
    ResponseEntity<ServiceResult<Object>> response;
    
    try {
      
      String tenantId = obtenerTenantId(httpRequest);
      
      resultado = this.procesosService.listarProcesoService(tenantId);
      
      if ( resultado == null ) {
        resultado = new ServiceResult<>(false,
            "Error interno, no se pudo recuperar el proceso de lavado",
            ConstantesNumericas.CERO, null);
        response = ResponseEntity.status(ApiErrorCode.ERROR_INTERNO.getHttpStatus()).body(resultado);
      }
      else if ( !resultado.isSuccess() && resultado.getData() instanceof ApiErrorCode ) {
        ApiErrorCode error = (ApiErrorCode) resultado.getData();
        response = ResponseEntity.status(error.getHttpStatus()).body(resultado);
      }
      else {
        response = ResponseEntity.ok(resultado);
      }
      
    }
    catch ( Exception e ) {
      log.error("[Exception | Error critico al recuperar el proceso de lavado | Controller | Detalles: {}]",
          e.getMessage(), e);
      response = new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
    
    return response;
    
  }
  
}
