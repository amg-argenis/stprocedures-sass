package com.washtrack.washtrack_api.proceso.respository.inicializador;

import com.washtrack.washtrack_api.proceso.entity.ProcesosEntity;
import com.washtrack.washtrack_api.proceso.rowmapper.ProcesosRowmapper;
import com.washtrack.washtrack_api.proceso.util.MapearObjetosProcesos;
import com.washtrack.washtrack_api.util.constantes.ConstantesBaseDatos;
import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Component;

import java.sql.Types;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Component
public class InicializadorProcesosLavado {
  
  private SimpleJdbcCall insertarProceso;
  private SimpleJdbcCall buscarProceso;
  private SimpleJdbcCall listarProcesos;
  private SimpleJdbcCall actualizarProceso;
  private SimpleJdbcCall eliminarProceso;
  
  private final JdbcTemplate jdbcTemplate;
  private final MapearObjetosProcesos mapearObjetosProcesos;
  
  public InicializadorProcesosLavado(JdbcTemplate jdbcTemplate, MapearObjetosProcesos mapearObjetosProcesos) {
    this.jdbcTemplate = jdbcTemplate;
    this.mapearObjetosProcesos = mapearObjetosProcesos;
  }
  
  @PostConstruct
  public void init() {
    this.insertarProceso = new SimpleJdbcCall(this.jdbcTemplate)
        .withCatalogName(ConstantesBaseDatos.WASHTRACKDB)
        .withProcedureName(ConstantesBaseDatos.SP_INSERTAR_PROCESO)
        .declareParameters(
            // IN
            
            new SqlParameter("pa_idproceso", Types.VARCHAR),
            new SqlParameter("pa_tenantid", Types.VARCHAR),
            new SqlParameter("pa_nombre", Types.VARCHAR),
            new SqlParameter("pa_descripcion", Types.VARCHAR),
            new SqlParameter("pa_preciounitario", Types.DECIMAL),
            // OUT control
            new SqlOutParameter("pa_codigobd", Types.INTEGER),
            new SqlOutParameter("pa_mensaje", Types.VARCHAR)
        )
        .returningResultSet("procesoinsertado", new ProcesosRowmapper());
    
    this.actualizarProceso = new SimpleJdbcCall(this.jdbcTemplate)
        .withCatalogName(ConstantesBaseDatos.WASHTRACKDB)
        .withProcedureName(ConstantesBaseDatos.SP_ACTUALIZAR_PROCESO)
        .declareParameters(
            // IN
            
            new SqlParameter("pa_idproceso", Types.VARCHAR),
            new SqlParameter("pa_tenantid", Types.VARCHAR),
            new SqlParameter("pa_nombre", Types.VARCHAR),
            new SqlParameter("pa_descripcion", Types.VARCHAR),
            new SqlParameter("pa_preciounitario", Types.DECIMAL),
            // OUT control
            new SqlOutParameter("pa_codigobd", Types.INTEGER),
            new SqlOutParameter("pa_mensaje", Types.VARCHAR)
        )
        .returningResultSet("procesoactualizado", new ProcesosRowmapper());
    
    this.eliminarProceso = new SimpleJdbcCall(this.jdbcTemplate)
        .withCatalogName(ConstantesBaseDatos.WASHTRACKDB)
        .withProcedureName(ConstantesBaseDatos.SP_ELIMINAR_PROCESO)
        .declareParameters(
            // IN
            
            new SqlParameter("pa_idproceso", Types.VARCHAR),
            new SqlParameter("pa_tenantid", Types.VARCHAR),
            // OUT control
            new SqlOutParameter("pa_codigobd", Types.INTEGER),
            new SqlOutParameter("pa_mensaje", Types.VARCHAR)
        );
    
    this.buscarProceso = new SimpleJdbcCall(this.jdbcTemplate)
        .withCatalogName(ConstantesBaseDatos.WASHTRACKDB)
        .withProcedureName(ConstantesBaseDatos.SP_BUSCAR_PROCESO)
        .declareParameters(
            // IN
            new SqlParameter("pa_codigoproceso", Types.VARCHAR),
            new SqlParameter("pa_tenantid", Types.VARCHAR),
            // OUT
            new SqlOutParameter("pa_codigobd", Types.INTEGER),
            new SqlOutParameter("pa_mensaje", Types.VARCHAR)
        )
        .returningResultSet("procesorecuperado", new ProcesosRowmapper());
    
    this.listarProcesos = new SimpleJdbcCall(this.jdbcTemplate)
        .withCatalogName(ConstantesBaseDatos.WASHTRACKDB)
        .withProcedureName(ConstantesBaseDatos.SP_LISTAR_PROCESOS)
        .declareParameters(
            // IN
            new SqlParameter("pa_tenantid", Types.VARCHAR),
            // OUT
            new SqlOutParameter("pa_codigobd", Types.INTEGER),
            new SqlOutParameter("pa_mensaje", Types.VARCHAR)
        )
        .returningResultSet("listaprocesos", new ProcesosRowmapper());
  }
  
  // EJECUCIONES EN BD *************************************************************************************************
  
  public Map<String, Object> insertarProcesoLavadoExe(ProcesosEntity procesos) {
    Map<String, Object> paramMap = this.mapearObjetosProcesos.parametrizarProcesosInsert(procesos);
    log.info("[Parametros del nuevo proceso a insertar | Detalle: {}]", paramMap);
    return this.insertarProceso.execute(paramMap);
  }
  
  public Map<String, Object> actualizarProcesoLavadoExe(ProcesosEntity procesos) {
    Map<String, Object> paramMap = this.mapearObjetosProcesos.parametrizarProcesosUpdate(procesos);
    log.info("[Parametros del nuevo proceso para actualizar | Detalle: {}]", paramMap);
    return this.actualizarProceso.execute(paramMap);
  }
  
  public Map<String, Object> eliminarProcesoLavadoExe(String idproceso, String tenantid) {
    Map<String, Object> paramMap = new HashMap<>();
    paramMap.put("pa_idproceso", idproceso);
    paramMap.put("pa_tenantid", tenantid);
    log.info("[Parametros del nuevo proceso para actualizar | Detalle: {}]", paramMap);
    return this.eliminarProceso.execute(paramMap);
  }
  
  public Map<String, Object> buscarProcesoLavadoExe(String codigoProceso, String tenantid) {
    Map<String, Object> paramMap = new HashMap<String, Object>();
    paramMap.put("pa_codigoproceso", codigoProceso);
    paramMap.put("pa_tenantid", tenantid);
    log.info("[Parametros del proceso de lavado a buscar | Detalle: {}]", paramMap);
    return this.buscarProceso.execute(paramMap);
  }
  
  public Map<String, Object> listarProcesosLavadoExe(String tenantid) {
    Map<String, Object> paramMap = new HashMap<String, Object>();
    paramMap.put("pa_tenantid", tenantid);
    log.info("[Parametros para obtener el listado de procesos de lavado | Detalle: {}]", paramMap);
    return this.listarProcesos.execute(paramMap);
  }
  
}
