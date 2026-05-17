package com.washtrack.washtrack_api.util.response;

import lombok.Data;

@Data
public class ServiceResult<T> {
  
  private boolean success;
  private String message;
  private int registros;
  private T data;
  
  public ServiceResult(boolean success, String message, int registros, T data) {
    this.success = success;
    this.message = message;
    this.registros = registros;
    this.data = data;
  }
}
