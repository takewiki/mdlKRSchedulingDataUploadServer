
#' 处理逻辑
#'
#' @param input 输入
#' @param output 输出
#' @param session 会话
#' @param dms_token 口令
#'
#' @return 返回值
#' @export
#'
#' @examples
#' SchedulingDataUploadServer()
SchedulingDataUploadServer <- function(input,output,session,dms_token) {


  #获取参数
  text_file_SchedulingData_upload = tsui::var_file("text_file_SchedulingData_upload")



  shiny::observeEvent(input$btn_SchedulingData_upload,{

    filename =text_file_SchedulingData_upload()



    if(filename==''  || is.null(filename)){

      tsui::pop_notice("请先上传文件")


    }else{

      data <- readxl::read_excel(filename,col_types = c("text", "text", "text",
                                                        "text", "text", "text", "text", "text",
                                                        "numeric", "text", "text", "text"))

      data = as.data.frame(data)
      data = tsdo::na_standard(data)

      tsda::db_writeTable2(token = dms_token,table_name = 'rds_src_t_SchedulingData_input',r_object = data,append = TRUE)


      mdlKRSchedulingDataUploadPkg::SchedulingData_upload(dms_token = dms_token)
      tsui::pop_notice("上传成功")
    }

  })

}

#' 处理逻辑
#'
#' @param input 输入
#' @param output 输出
#' @param session 会话
#' @param dms_token 口令
#'
#' @return 返回值
#' @export
#'
#' @examples
#' SchedulingDataViewServer()
SchedulingDataViewServer <- function(input,output,session,dms_token) {


  #获取参数
  text_file_SchedulingData_FBillNo = tsui::var_text("text_file_SchedulingData_FBillNo")



  shiny::observeEvent(input$btn_SchedulingData_view,{

    FBillNo =text_file_SchedulingData_FBillNo()

    data = mdlKRSchedulingDataUploadPkg::SchedulingData_view(dms_token = dms_token,FBillNo=FBillNo)

    tsui::run_dataTable2(id = 'SchedulingData_resultView',data = data)


    tsui::run_download_xlsx(id = 'dl_SchedulingData_download',data =data ,filename = '排产数据.xlsx')


  })

}


#' 处理逻辑
#'
#' @param input 输入
#' @param output 输出
#' @param session 会话
#' @param dms_token 口令
#'
#' @return 返回值
#' @export
#'
#' @examples
#' SchedulingDataServer()
SchedulingDataServer <- function(input,output,session,dms_token) {

  SchedulingDataUploadServer(input = input,output = output,session = session,dms_token = dms_token)
  SchedulingDataViewServer(input = input,output = output,session = session,dms_token = dms_token)


}
