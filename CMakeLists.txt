cmake_minimum_required(VERSION 2.8)
project(gstrtspserver-1.0)


macro( project_group source_files sgbd_cur_dir)
    if(MSVC)
        foreach(sgbd_file ${${source_files}})
            string(REGEX REPLACE ${sgbd_cur_dir}/\(.*\) \\1 sgbd_fpath ${sgbd_file})
			string(REGEX REPLACE "\(.*\)/.*" \\1 sgbd_group_name ${sgbd_fpath})
            string(COMPARE EQUAL ${sgbd_fpath} ${sgbd_group_name} sgbd_nogroup)
            string(REPLACE "/" "\\" sgbd_group_name ${sgbd_group_name})
            if(sgbd_nogroup)
                set(sgbd_group_name "\\")
            endif(sgbd_nogroup)
            source_group(${sgbd_group_name} FILES ${sgbd_file})
        endforeach(sgbd_file)
    endif()
endmacro(project_group)

file(GLOB_RECURSE  LWS_SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/src/gst/rtsp-server/*.[ch] ${CMAKE_CURRENT_SOURCE_DIR}/src/gst/rtsp-server/*.c)

project_group(LWS_SOURCES ${CMAKE_CURRENT_SOURCE_DIR})


find_package(PkgConfig 0.29.1 REQUIRED)

pkg_check_modules(GST_MODULES  REQUIRED
                  gstreamer-1.0>=1.14.0
                  gstreamer-base-1.0>=1.14.0
                  )

include_directories($ENV{GSTREAMER_ROOT}/include)
include_directories($ENV{GSTREAMER_ROOT}/include/gstreamer-1.0)
include_directories($ENV{GSTREAMER_ROOT}/include/glib-2.0)
include_directories($ENV{GSTREAMER_ROOT}/lib/glib-2.0/include)

link_directories($ENV{GSTREAMER_ROOT}/lib $ENV{GSTREAMER_ROOT}/bin)

add_library(gstrtspserver-1.0  SHARED ${LWS_SOURCES})

target_link_libraries(gstrtspserver-1.0  gstrtp-1.0
                                    gstrtsp-1.0
                                    gstsdp-1.0
                                    gstapp-1.0
                                    gstreamer-1.0
                                    gobject-2.0
                                    glib-2.0
                                    gio-2.0
                                    gstbase-1.0
                                    gstnet-1.0
                                    )
                

ADD_DEFINITIONS( -DGST_USE_UNSTABLE_API  )
ADD_DEFINITIONS( -DVERSION="1.14.0"  )
ADD_DEFINITIONS( -DPACKAGE="gst-plugins-bad"  )
ADD_DEFINITIONS( -DGST_PACKAGE_NAME="GStreamer Bad Plug-ins source release"  )
ADD_DEFINITIONS( -DGST_PACKAGE_ORIGIN="Unknown package origin"  )

set(instd ${CMAKE_HOME_DIRECTORY}/../out)

install(TARGETS gstrtspserver-1.0
		RUNTIME DESTINATION ${instd}/bin
		LIBRARY DESTINATION ${instd}/lib
        )