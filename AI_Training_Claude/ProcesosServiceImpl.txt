package com.washtrack.washtrack_api.proceso.service.impl;

import com.washtrack.washtrack_api.proceso.dto.ProcesoUpdateRequest;
import com.washtrack.washtrack_api.proceso.dto.ProcesosDto;
import com.washtrack.washtrack_api.proceso.dto.ProcesosRequest;
import com.washtrack.washtrack_api.proceso.entity.ProcesosEntity;
import com.washtrack.washtrack_api.proceso.response.ProcesosResponseRepository;
import com.washtrack.washtrack_api.proceso.respository.IProcesosRepository;
import com.washtrack.washtrack_api.proceso.service.IProcesosService;
import com.washtrack.washtrack_api.proceso.util.MapearObjetosProcesos;
import com.washtrack.washtrack_api.util.constantes.ConstantesMensajesGenericos;
import com.washtrack.washtrack_api.util.constantes.ConstantesNumericas;
import com.washtrack.washtrack_api.util.exceptions.ApiErrorCode;
import com.washtrack.washtrack_api.util.response.MapearRespuestasConsultasUtil;
import com.washtrack.washtrack_api.util.response.ServiceResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
public class ProcesosServiceImpl implements IProcesosService {
  
  private final IProcesosRepository procesosRepository;
  private final MapearObjetosProcesos mapearObjetosProcesos;
  private final MapearRespuestasConsultasUtil mapearRespuestasConsultas;
  
  public ProcesosServiceImpl(IProcesosRepository procesosRepository, MapearObjetosProcesos mapearObjetosProcesos,
      MapearRespuestasConsultasUtil mapearRespuestasConsultas) {
    this.procesosRepository = procesosRepository;
    this.mapearObjetosProcesos = mapearObjetosProcesos;
    this.mapearRespuestasConsultas = mapearRespuestasConsultas;
  }
  
  @Override
  public ServiceResult<Object> insertarProcesoService(ProcesosRequest procesosRequest) {
    log.info("[Inicia insertar proceso de lavado | Service]");
    
    ServiceResult<Object> serviceResult = null;
    
    try {
      // Mapear DTO → Entity (request)
      ProcesosEntity procesosEntity = this.mapearObjetosProcesos.mapearFromDtoToEntity(procesosRequest);
      
      // UUID par idEntrega
      UUID uuid = UUID.randomUUID();
      procesosEntity.setIdproceso(uuid.toString());
      log.info("[Proceso de lavado a insertar: ({}) | Service]", procesosEntity);
      
      // Llamada al Repository
      ProcesosResponseRepository resultado =
          this.procesosRepository.insertarProcesoRepository(procesosEntity);
      
      // Mapear Entity → DTO (response)
      if ( resultado.getProcesosEntity() != null
          && resultado.getCodigobd().intValue() == ConstantesNumericas.CERO ) {
        ProcesosDto procesosDto =
            this.mapearObjetosProcesos.mapearFromEntityToDto(resultado.getProcesosEntity());
        serviceResult = this.mapearRespuestasConsultas.mapearserviceResultRespuestaOk(
            ConstantesMensajesGenericos.OPERACION_EXITOSA,
            ConstantesNumericas.UNO, procesosDto
        );
      }
      
      if ( resultado.getProcesosEntity() == null
          && resultado.getCodigobd().intValue() == ConstantesNumericas.UNONEGATIVO ) {
        log.info("[Proceso de lavado no insertado en la BD | Service]");
        serviceResult = this.mapearRespuestasConsultas.mapearserviceResultError(
            ConstantesMensajesGenericos.ERROR_INSERT,
            ApiErrorCode.ERROR_BASE_DATOS
        );
      }
      
      if ( resultado.getProcesosEntity() == null
          && resultado.getCodigobd().intValue() == ConstantesNumericas.DOS ) {
        log.info("[El proceso de lavado ya existe en la BD | Service]");
        serviceResult = this.mapearRespuestasConsultas.mapearserviceResultError(
            ConstantesMensajesGenericos.ERROR_INSERT,
            ApiErrorCode.CONFLICTO_INTEGRIDAD
        );
      }
    }
    catch ( NullPointerException e ) {
      log.error("[NullPointerException | Error critico, alguno de los datos es NULL | Service |  Mas detalles: {}]",
          e.getMessage(), e);
      serviceResult =
          this.mapearRespuestasConsultas.mapearserviceResultError(
              ConstantesMensajesGenericos.ERROR_BD,
              ApiErrorCode.ERROR_INTERNO
          );
    }
    catch ( DataAccessException e ) {
      log.error(
          "[DataAccessException | Error al insertar el proceso de lavado "
              + "| Service | Mas detalles: {}]", e.getMessage(), e);
      serviceResult =
          this.mapearRespuestasConsultas.mapearserviceResultError(
              ConstantesMensajesGenericos.ERROR_BD,
              ApiErrorCode.ERROR_BASE_DATOS
          );
    }
    catch ( Exception e ) {
      log.error(
          "[Exception | Error critico al insertar el proceso de lavado | Service | Mas detalles: {}]",
          e.getMessage(), e);
      serviceResult =
          this.mapearRespuestasConsultas.mapearserviceResultError(
              ConstantesMensajesGenericos.ERROR_BD,
              ApiErrorCode.ERROR_INTERNO
          );
    }
    finally {
      log.info("[Finaliza insertar proceso de lavado | Service]");
    }
    
    return serviceResult;
  }
  
  @Override
  public ServiceResult<Object> actualizarProcesoService(ProcesoUpdateRequest procesosRequest) {
    log.info("[Inicia actualizar proceso de lavado | Service]");
    
    ServiceResult<Object> serviceResult = null;
    
    try {
      // Mapear DTO → Entity (request)
      ProcesosEntity procesosEntity = this.mapearObjetosProcesos.mapearFromDtoToEntity(procesosRequest);
      
      // UUID par idEntrega
      UUID uuid = UUID.randomUUID();
      procesosEntity.setIdproceso(uuid.toString());
      log.info("[Proceso de lavado para actualizar: ({}) | Service]", procesosEntity);
      
      // Llamada al Repository
      ProcesosResponseRepository resultado =
          this.procesosRepository.actualizarProcesoRepository(procesosEntity);
      
      // Mapear Entity → DTO (response)
      if ( resultado.getProcesosEntity() != null
          && resultado.getCodigobd().intValue() == ConstantesNumericas.CERO ) {
        ProcesosDto procesosDto =
            this.mapearObjetosProcesos.mapearFromEntityToDto(resultado.getProcesosEntity());
        serviceResult = this.mapearRespuestasConsultas.mapearserviceResultRespuestaOk(
            ConstantesMensajesGenericos.OPERACION_EXITOSA,
            ConstantesNumericas.UNO, procesosDto
        );
      }
      
      if ( resultado.getProcesosEntity() == null
          && resultado.getCodigobd().intValue() == ConstantesNumericas.UNONEGATIVO ) {
        log.info("[Proceso de lavado no actualizado en la BD | Service]");
        serviceResult = this.mapearRespuestasConsultas.mapearserviceResultError(
            ConstantesMensajesGenericos.ERROR_ACTUALIZAR,
            ApiErrorCode.ERROR_BASE_DATOS
        );
      }
      
      if ( resultado.getProcesosEntity() == null
          && resultado.getCodigobd().intValue() == ConstantesNumericas.DOS ) {
        log.info("[El proceso de lavado no existe en la BD | Service]");
        serviceResult = this.mapearRespuestasConsultas.mapearserviceResultError(
            ConstantesMensajesGenericos.ERROR_ACTUALIZAR,
            ApiErrorCode.CONFLICTO_INTEGRIDAD
        );
      }
    }
    catch ( NullPointerException e ) {
      log.error("[NullPointerException | Error critico, alguno de los datos es NULL | Service |  Mas detalles: {}]",
          e.getMessage(), e);
      serviceResult =
          this.mapearRespuestasConsultas.mapearserviceResultError(
              ConstantesMensajesGenericos.ERROR_BD,
              ApiErrorCode.ERROR_INTERNO
          );
    }
    catch ( DataAccessException e ) {
      log.error(
          "[DataAccessException | Error al actualizar el proceso de lavado "
              + "| Service | Mas detalles: {}]", e.getMessage(), e);
      serviceResult =
          this.mapearRespuestasConsultas.mapearserviceResultError(
              ConstantesMensajesGenericos.ERROR_BD,
              ApiErrorCode.ERROR_BASE_DATOS
          );
    }
    catch ( Exception e ) {
      log.error(
          "[Exception | Error critico al actualizar el proceso de lavado | Service | Mas detalles: {}]",
          e.getMessage(), e);
      serviceResult =
          this.mapearRespuestasConsultas.mapearserviceResultError(
              ConstantesMensajesGenericos.ERROR_BD,
              ApiErrorCode.ERROR_INTERNO
          );
    }
    finally {
      log.info("[Finaliza actualizar proceso de lavado | Service]");
    }
    
    return serviceResult;
  }
  
  @Override
  public ServiceResult<Object> eliminarProcesoService(String idproceso, String tenantid) {
    log.info("[Inicia eliminar proceso de lavado | Service]");
    
    ServiceResult<Object> serviceResult = null;
    
    try {
      // Mapear DTO → Entity (request)
      
      log.info("[Proceso de lavado para actualizar: (IdProceso: {}, Tenant Id: {}) | Service]", idproceso, tenantid);
      
      // Llamada al Repository
      ProcesosResponseRepository resultado =
          this.procesosRepository.eliminarProcesoRepository(idproceso, tenantid);
      
      // Mapear Entity → DTO (response)
      if ( resultado.getCodigobd() != null && resultado.getCodigobd().intValue() == ConstantesNumericas.CERO ) {
        serviceResult = this.mapearRespuestasConsultas.mapearserviceResultRespuestaOk(
            ConstantesMensajesGenericos.OPERACION_EXITOSA,
            ConstantesNumericas.UNO, null
        );
      }
      
      if ( resultado.getCodigobd() != null && resultado.getCodigobd().intValue() == ConstantesNumericas.UNONEGATIVO ) {
        log.info("[Proceso de lavado no actualizado en la BD | Service]");
        serviceResult = this.mapearRespuestasConsultas.mapearserviceResultError(
            ConstantesMensajesGenericos.ERROR_ELIMINAR,
            ApiErrorCode.ERROR_BASE_DATOS
        );
      }
      
      if ( resultado.getCodigobd() != null && resultado.getCodigobd().intValue() == ConstantesNumericas.DOS ) {
        log.info("[El proceso de lavado no existe en la BD | Service]");
        serviceResult = this.mapearRespuestasConsultas.mapearserviceResultError(
            ConstantesMensajesGenericos.ERROR_ELIMINAR,
            ApiErrorCode.CONFLICTO_INTEGRIDAD
        );
      }
    }
    catch ( NullPointerException e ) {
      log.error("[NullPointerException | Error critico, alguno de los datos es NULL | Service |  Mas detalles: {}]",
          e.getMessage(), e);
      serviceResult =
          this.mapearRespuestasConsultas.mapearserviceResultError(
              ConstantesMensajesGenericos.ERROR_BD,
              ApiErrorCode.ERROR_INTERNO
          );
    }
    catch ( DataAccessException e ) {
      log.error(
          "[DataAccessException | Error al eliminar el proceso de lavado "
              + "| Service | Mas detalles: {}]", e.getMessage(), e);
      serviceResult =
          this.mapearRespuestasConsultas.mapearserviceResultError(
              ConstantesMensajesGenericos.ERROR_BD,
              ApiErrorCode.ERROR_BASE_DATOS
          );
    }
    catch ( Exception e ) {
      log.error(
          "[Exception | Error critico al eliminar el proceso de lavado | Service | Mas detalles: {}]",
          e.getMessage(), e);
      serviceResult =
          this.mapearRespuestasConsultas.mapearserviceResultError(
              ConstantesMensajesGenericos.ERROR_BD,
              ApiErrorCode.ERROR_INTERNO
          );
    }
    finally {
      log.info("[Finaliza eliminar proceso de lavado | Service]");
    }
    
    return serviceResult;
  }
  
  @Override
  public ServiceResult<Object> buscarProcesoService(String codigoProceso, String tenantid) {
    log.info("[Inicia buscar proceso de lavado | Service]");
    
    log.info("[Buscar proceso de lavado request: (Id entrega: {}| Tenant Id: {}) | Service]", codigoProceso, tenantid);
    
    ServiceResult<Object> serviceResult = null;
    
    try {
      // Llamada al Repository
      ProcesosResponseRepository respuesta = this.procesosRepository.buscarProcesoRepository(codigoProceso, tenantid);
      
      if ( respuesta == null ) {
        log.info("[Proceso no encontrado en la BD | Service]");
        return this.mapearRespuestasConsultas.mapearserviceResultError(
            ConstantesMensajesGenericos.SIN_REGISTROS,
            ApiErrorCode.SIN_INFORMACION_EN_BD
        );
      }
      
      if ( respuesta.getCodigobd().intValue() == ConstantesNumericas.CERO ) {
        // Mapear Entity → DTO (respuesta)
        serviceResult = this.mapearRespuestasConsultas.mapearserviceResultRespuestaOk(
            ConstantesMensajesGenericos.OPERACION_EXITOSA,
            ConstantesNumericas.UNO, respuesta.getProcesosEntity()
        );
      }
      
      if ( respuesta.getCodigobd() != null && respuesta.getCodigobd().intValue() == ConstantesNumericas.UNONEGATIVO ) {
        log.info("[Hubo un error en la BD al buscar el proceso de lavado solicitado | Service]");
        serviceResult =
            this.mapearRespuestasConsultas.mapearserviceResultError(
                ConstantesMensajesGenericos.ERROR_BD,
                ApiErrorCode.ERROR_BASE_DATOS
            );
      }
      
      if ( respuesta.getCodigobd() != null && respuesta.getCodigobd().intValue() == ConstantesNumericas.DOS ) {
        log.info("[No existe el proceso de lavado solicitado en la BD | Service]");
        serviceResult =
            this.mapearRespuestasConsultas.mapearserviceResultError(
                ConstantesMensajesGenericos.ERROR_BD,
                ApiErrorCode.SIN_INFORMACION_EN_BD
            );
      }
      
    }
    catch ( NullPointerException e ) {
      log.error("[NullPointerException | Error critico, alguno de los datos es NULL | Service |  Mas detalles: {}]",
          e.getMessage(), e);
      serviceResult =
          this.mapearRespuestasConsultas.mapearserviceResultError(
              ConstantesMensajesGenericos.ERROR_BD,
              ApiErrorCode.ERROR_INTERNO
          );
    }
    catch ( DataAccessException e ) {
      log.error(
          "[DataAccessException | Error al buscar el proceso de lavado "
              + "| Service | Mas detalles: {}]", e.getMessage(), e);
      serviceResult =
          this.mapearRespuestasConsultas.mapearserviceResultError(
              ConstantesMensajesGenericos.ERROR_BD,
              ApiErrorCode.ERROR_BASE_DATOS
          );
    }
    catch ( Exception e ) {
      log.error(
          "[Exception | Error critico al buscar el proceso de lavado | Service | Mas detalles: {}]",
          e.getMessage(), e);
      serviceResult =
          this.mapearRespuestasConsultas.mapearserviceResultError(
              ConstantesMensajesGenericos.ERROR_BD,
              ApiErrorCode.ERROR_INTERNO
          );
    }
    finally {
      log.info("[Finaliza buscar proceso de lavado | Service]");
    }
    
    return serviceResult;
  }
  
  @Override
  public ServiceResult<Object> listarProcesoService(String tenantid) {
    log.info("[Inicia listar los procesos de lavado | Service]");
    
    ServiceResult<Object> serviceResult = null;
    
    try {
      // Llamada al Repository
      ProcesosResponseRepository respuesta = this.procesosRepository.listarProcesosRepository(tenantid);
      
      if ( respuesta == null || respuesta.getEntityList().isEmpty() ) {
        log.info("[Listado de procesos de lavado no encontrados en la BD | Service]");
        serviceResult = this.mapearRespuestasConsultas.mapearserviceResultError(
            ConstantesMensajesGenericos.SIN_REGISTROS,
            ApiErrorCode.SIN_INFORMACION_EN_BD
        );
      }
      else {
        List<ProcesosDto> procesosDtoList = new ArrayList<>();
        for (ProcesosEntity procesosEntity : respuesta.getEntityList()) {
          procesosDtoList.add(this.mapearObjetosProcesos.mapearFromEntityToDto(procesosEntity));
        }
        serviceResult =
            this.mapearRespuestasConsultas.mapearserviceResultRespuestaOk(
                ConstantesMensajesGenericos.OPERACION_EXITOSA,
                respuesta.getEntityList().size(),
                procesosDtoList);
      }
      
    }
    catch ( NullPointerException e ) {
      log.error("[NullPointerException | Error critico, alguno de los datos es NULL | Service |  Mas detalles: {}]",
          e.getMessage(), e);
      serviceResult =
          this.mapearRespuestasConsultas.mapearserviceResultError(
              ConstantesMensajesGenericos.ERROR_BD,
              ApiErrorCode.ERROR_INTERNO
          );
    }
    catch ( DataAccessException e ) {
      log.error(
          "[DataAccessException | Error al listar los procesos de lavado "
              + "| Service | Mas detalles: {}]", e.getMessage(), e);
      serviceResult =
          this.mapearRespuestasConsultas.mapearserviceResultError(
              ConstantesMensajesGenericos.ERROR_BD,
              ApiErrorCode.ERROR_BASE_DATOS
          );
    }
    catch ( Exception e ) {
      log.error(
          "[Exception | Error critico al listar los procesos de lavado | Service | Mas detalles: {}]",
          e.getMessage(), e);
      serviceResult =
          this.mapearRespuestasConsultas.mapearserviceResultError(
              ConstantesMensajesGenericos.ERROR_BD,
              ApiErrorCode.ERROR_INTERNO
          );
    }
    finally {
      log.info("[Finaliza listar los procesos de lavado | Service]");
    }
    
    return serviceResult;
  }
}
