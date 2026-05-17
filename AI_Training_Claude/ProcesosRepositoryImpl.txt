package com.washtrack.washtrack_api.proceso.respository.impl;

import com.washtrack.washtrack_api.proceso.entity.ProcesosEntity;
import com.washtrack.washtrack_api.proceso.response.ProcesosResponseRepository;
import com.washtrack.washtrack_api.proceso.respository.IProcesosRepository;
import com.washtrack.washtrack_api.proceso.respository.inicializador.InicializadorProcesosLavado;
import com.washtrack.washtrack_api.util.constantes.ConstantesBaseDatos;
import com.washtrack.washtrack_api.util.constantes.ConstantesNumericas;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Slf4j
@Repository
public class ProcesosRepositoryImpl implements IProcesosRepository {
  
  private final InicializadorProcesosLavado inicializadorProcesosLavado;
  
  public ProcesosRepositoryImpl(InicializadorProcesosLavado inicializadorProcesosLavado) {
    this.inicializadorProcesosLavado = inicializadorProcesosLavado;
  }
  
  @Override
  public ProcesosResponseRepository insertarProcesoRepository(ProcesosEntity proceso) {
    log.info("[Inicia insertar proceso de lavado | Repository]");
    
    ProcesosResponseRepository responseRepository = new ProcesosResponseRepository();
    
    try {
      Map<String, Object> respuesta =
          this.inicializadorProcesosLavado.insertarProcesoLavadoExe(proceso);
      
      Integer codigobd = (Integer) respuesta.get(ConstantesBaseDatos.CODIGOBD);
      String mensajebd = (String) respuesta.get(ConstantesBaseDatos.PAMENSAJEBD);
      
      log.info("[Repository | Respuesta BD, Codigo: {} | Mensaje: {} | Repository]", codigobd, mensajebd);
      
      responseRepository.setCodigobd(codigobd);
      responseRepository.setProcesosEntity(null);
      responseRepository.setEntityList(new ArrayList<>());
      
      if ( codigobd != null && codigobd.intValue() == ConstantesNumericas.CERO ) {
        responseRepository.setEntityList((List<ProcesosEntity>) respuesta.get("procesoinsertado"));
        if ( !responseRepository.getEntityList().isEmpty() ) {
          responseRepository.setProcesosEntity(responseRepository.getEntityList().get(ConstantesNumericas.CERO));
          log.info("[Proceso de lavado insertado correctamente en la BD | Repository]");
        }
      }
      
      if ( codigobd == null || codigobd.intValue() == ConstantesNumericas.UNONEGATIVO ) {
        log.warn("[El SP para insertar proceso de lavado devolvio -1, se asume error]");
      }
      
      if ( codigobd != null && codigobd.intValue() == ConstantesNumericas.DOS ) {
        log.warn("[El proceso de lavado ya existe en la BD | Repository]");
      }
      
    }
    catch ( DataAccessException e ) {
      log.error("[DataAccessException | Error critico al insertar proceso de lavado en BD | Repository | Detalles: {}]",
          e.getMessage(), e);
      throw e;
    }
    catch ( Exception e ) {
      log.error("[Exception | Error critico al insertar proceso de lavado en BD | Repository | Detalles: {}]",
          e.getMessage(), e);
      throw e;
    }
    finally {
      log.info("[Finaliza insertar proceso de lavado | Repository]");
    }
    
    return responseRepository;
  }
  
  @Override
  public ProcesosResponseRepository actualizarProcesoRepository(ProcesosEntity proceso) {
    log.info("[Inicia actualizar proceso de lavado | Repository]");
    
    ProcesosResponseRepository responseRepository = new ProcesosResponseRepository();
    
    try {
      Map<String, Object> respuesta =
          this.inicializadorProcesosLavado.actualizarProcesoLavadoExe(proceso);
      
      Integer codigobd = (Integer) respuesta.get(ConstantesBaseDatos.CODIGOBD);
      String mensajebd = (String) respuesta.get(ConstantesBaseDatos.PAMENSAJEBD);
      
      log.info("[Repository | Respuesta BD, Codigo: {} | Mensaje: {} | Repository]", codigobd, mensajebd);
      
      responseRepository.setCodigobd(codigobd);
      responseRepository.setProcesosEntity(null);
      responseRepository.setEntityList(new ArrayList<>());
      
      if ( codigobd != null && codigobd.intValue() == ConstantesNumericas.CERO ) {
        responseRepository.setEntityList((List<ProcesosEntity>) respuesta.get("procesoactualizado"));
        if ( !responseRepository.getEntityList().isEmpty() ) {
          responseRepository.setProcesosEntity(responseRepository.getEntityList().get(ConstantesNumericas.CERO));
          log.info("[Proceso de lavado actualizado correctamente en la BD | Repository]");
        }
      }
      
      if ( codigobd == null || codigobd.intValue() == ConstantesNumericas.UNONEGATIVO ) {
        log.warn("[El SP para actualizar proceso de lavado devolvio -1, se asume error]");
      }
      
      if ( codigobd != null && codigobd.intValue() == ConstantesNumericas.DOS ) {
        log.warn("[El proceso de lavado no existe en la BD | Repository]");
      }
      
    }
    catch ( DataAccessException e ) {
      log.error(
          "[DataAccessException | Error critico al actualizar el proceso de lavado en BD | Repository | Detalles: {}]",
          e.getMessage(), e);
      throw e;
    }
    catch ( Exception e ) {
      log.error("[Exception | Error critico al actualizar el proceso de lavado en BD | Repository | Detalles: {}]",
          e.getMessage(), e);
      throw e;
    }
    finally {
      log.info("[Finaliza actualizar proceso de lavado | Repository]");
    }
    
    return responseRepository;
  }
  
  @Override
  public ProcesosResponseRepository eliminarProcesoRepository(String idproceso, String tenantid) {
    log.info("[Inicia eliminar proceso de lavado | Repository]");
    
    ProcesosResponseRepository responseRepository = new ProcesosResponseRepository();
    
    try {
      Map<String, Object> respuesta =
          this.inicializadorProcesosLavado.eliminarProcesoLavadoExe(idproceso, tenantid);
      
      Integer codigobd = (Integer) respuesta.get(ConstantesBaseDatos.CODIGOBD);
      String mensajebd = (String) respuesta.get(ConstantesBaseDatos.PAMENSAJEBD);
      
      log.info("[Repository | Respuesta BD, Codigo: {} | Mensaje: {} | Repository]", codigobd, mensajebd);
      
      responseRepository.setCodigobd(codigobd);
      responseRepository.setProcesosEntity(null);
      responseRepository.setEntityList(new ArrayList<>());
      
      if ( codigobd != null && codigobd.intValue() == ConstantesNumericas.CERO ) {
        responseRepository.setCodigobd(codigobd);
        log.info("[Proceso de lavado eliminado correctamente en la BD | Repository]");
      }
      
      if ( codigobd == null || codigobd.intValue() == ConstantesNumericas.UNONEGATIVO ) {
        log.warn("[El SP para eliminar proceso de lavado devolvio -1, se asume error]");
      }
      
      if ( codigobd != null && codigobd.intValue() == ConstantesNumericas.DOS ) {
        log.warn("[El proceso de lavado no existe en la BD | Repository]");
      }
      
    }
    catch ( DataAccessException e ) {
      log.error(
          "[DataAccessException | Error critico al eliminar el proceso de lavado en BD | Repository | Detalles: {}]",
          e.getMessage(), e);
      throw e;
    }
    catch ( Exception e ) {
      log.error("[Exception | Error critico al eliminar el proceso de lavado en BD | Repository | Detalles: {}]",
          e.getMessage(), e);
      throw e;
    }
    finally {
      log.info("[Finaliza eliminar proceso de lavado | Repository]");
    }
    
    return responseRepository;
  }
  
  @Override
  public ProcesosResponseRepository buscarProcesoRepository(String codigoProceso, String tenantid) {
    log.info("[Inicia buscar proceso de lavado | Repository]");
    
    ProcesosResponseRepository responseRepository = new ProcesosResponseRepository();
    
    try {
      Map<String, Object> respuesta =
          this.inicializadorProcesosLavado.buscarProcesoLavadoExe(codigoProceso, tenantid);
      
      Integer codigobd = (Integer) respuesta.get(ConstantesBaseDatos.CODIGOBD);
      String mensajebd = (String) respuesta.get(ConstantesBaseDatos.PAMENSAJEBD);
      
      log.info("[Repository | Respuesta BD, Codigo: {} | Mensaje: {}]", codigobd, mensajebd);
      
      responseRepository.setCodigobd(codigobd);
      responseRepository.setProcesosEntity(null);
      responseRepository.setEntityList(new ArrayList<>());
      
      if ( codigobd != null && codigobd.intValue() == ConstantesNumericas.CERO ) {
        responseRepository.setEntityList((List<ProcesosEntity>) respuesta.get("procesorecuperado"));
        if ( !responseRepository.getEntityList().isEmpty() ) {
          responseRepository.setProcesosEntity(responseRepository.getEntityList().get(ConstantesNumericas.CERO));
          log.info("[Proceso de lavado recuperado correctamente de la BD | Repository]");
        }
      }
      
      if ( codigobd == null || codigobd.intValue() == ConstantesNumericas.UNONEGATIVO ) {
        log.warn("[El SP buscar proceso fallo, se asume error | Repository]");
      }
      
      if ( codigobd != null && codigobd.intValue() == ConstantesNumericas.DOS ) {
        log.warn("[Proceso de lavado no encontrada en la BD | Repository]");
      }
      
    }
    catch ( DataAccessException e ) {
      log.error("[DataAccessException | Error critico al buscar el proceso de lavado en BD | Repository"
          + " | Detalles: {}]", e.getMessage(), e);
      throw e;
    }
    catch ( Exception e ) {
      log.error("[Exception | Error critico al buscar el proceso de lavado en BD | Repository "
          + " | Detalles: {}]", e.getMessage(), e);
      throw e;
    }
    finally {
      log.info("[Finaliza buscar proceso de lavado | Repository]");
    }
    
    return responseRepository;
  }
  
  @Override
  public ProcesosResponseRepository listarProcesosRepository(String tenantid) {
    log.info("[Inicia listar procesos de lavado | Repository]");
    
    ProcesosResponseRepository responseRepository = new ProcesosResponseRepository();
    List<ProcesosEntity> entityList;
    
    try {
      Map<String, Object> respuesta =
          this.inicializadorProcesosLavado.listarProcesosLavadoExe(tenantid);
      
      Integer codigobd = (Integer) respuesta.get(ConstantesBaseDatos.CODIGOBD);
      String mensajebd = (String) respuesta.get(ConstantesBaseDatos.PAMENSAJEBD);
      
      log.info("[Repository | Respuesta BD, Codigo: {} | Mensaje: {}]", codigobd, mensajebd);
      
      responseRepository.setCodigobd(codigobd);
      responseRepository.setProcesosEntity(null);
      responseRepository.setEntityList(new ArrayList<>());
      
      if ( codigobd != null && codigobd.intValue() == ConstantesNumericas.CERO ) {
        responseRepository.setEntityList((List<ProcesosEntity>) respuesta.get("listaprocesos"));
        if ( !responseRepository.getEntityList().isEmpty() ) {
          log.info("[Listado de procesos de lavado recuperado correctamente de la BD | Repository]");
        }
      }
      
      if ( codigobd == null || codigobd.intValue() == ConstantesNumericas.UNONEGATIVO ) {
        log.warn("[El SP listar procesos fallo, se asume error]");
      }
      
      if ( codigobd != null && codigobd.intValue() == ConstantesNumericas.DOS ) {
        log.warn("[Registros de procesos No encontrados en la BD | Repository]");
      }
      
    }
    catch ( DataAccessException e ) {
      log.error("[DataAccessException | Error critico al listar los procesos de lavado en BD | Repository"
          + " | Detalles: {}]", e.getMessage(), e);
      throw e;
    }
    catch ( Exception e ) {
      log.error("[Exception | Error critico al listar los procesos de lavado en BD | Repository "
          + " | Detalles: {}]", e.getMessage(), e);
      throw e;
    }
    finally {
      log.info("[Finaliza listar procesos de lavado | Repository]");
    }
    
    return responseRepository;
  }
}
