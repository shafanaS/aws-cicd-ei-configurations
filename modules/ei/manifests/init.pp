# ----------------------------------------------------------------------------
#  Copyright (c) 2018 WSO2, Inc. http://www.wso2.org
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# ----------------------------------------------------------------------------

# Class: ei
# Init class of EI Integrator default profile
class ei (
)

  inherits ei::params {

  # Copy configuration changes to the installed directory
  $template_list.each | String $template | {
    file { "$wso2_path/$product-$product_version/${template}":
    # file { "$wso2_path/${template}":
      ensure  => file,
      mode    => '0644',
      content => template("${puppet_modules_path}/${module_name}/templates/carbon-home/${template}.erb")
    }
  }

  # Copy wso2server.sh to installed directory
    file { "$wso2_path/$product-$product_version/${start_script_template}":
    ensure  => file,
    mode    => '0754',
    content => template("${puppet_modules_path}/${module_name}/templates/carbon-home/${start_script_template}.erb")
  }

  # Copy mysql-connector-java-5.1.41-bin.jar to installed directory
  file { "$wso2_path/$product-$product_version/lib/${mysql_connector}":
    mode   => '0754',
    source => "puppet:///modules/${module_name}/lib/${mysql_connector}",
  }

  # Download patch file
  download_file { "Download patch file" :
    url                   => 'https://wso2-patches.s3-us-west-2.amazonaws.com/patch9999.zip',
    destination_directory => '${puppet_modules_path}/patch'
  }

  #unzip patch file
    exec { "unzip-patch-file":
      command     => "unzip ${puppet_modules_path}/patch/${patch_file} -d $wso2_path/$product-$product_version/patches/",
      path        => "/usr/bin/",
      cwd         => "${puppet_modules_path}",
      refreshonly => true,
    }

}
