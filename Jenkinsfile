@Library("shared-libraries")

import io.libs.Utils
import io.libs.Telegram
import groovy.transform.Field

def utils = new Utils()

@Field
List<String> jenkinsAgent_values = ['DEV-1C-UPD', 'DEV-1C', 'v_silchenkov']

@Field
List<String> command_file_values = ['update_PP'
                                ]

pipeline {

    parameters {

       choice(name: 'command_file',
                choices: (params.command_file ? [params.command_file] : []) +
                             (command_file_values - 
                                 (params.command_file ? [params.command_file] : [])),
                description: 'Сценарий')
      
       choice(name: 'jenkinsAgent',
                choices: (params.jenkinsAgent ? [params.jenkinsAgent] : []) +
                             (jenkinsAgent_values - 
                                 (params.jenkinsAgent ? [params.jenkinsAgent] : [])),
                description: 'Нода дженкинса, на которой запускать пайплайн. По умолчанию master')

        text(defaultValue: "${env.listMetadataBuild}", description: 'Список метаданных, которые требуется обновить. Используется в сценариях с префиксом \"meta_\".' + '\n' +'Напишите символ *, чтобы обновить полностью все метаданные.', name: 'listMetadataBuild')
        booleanParam(defaultValue: "${env.includeChildObjects}", description: 'Обновлять объекты из списка метаданных рекурсивно', name: 'includeChildObjects')
        booleanParam(defaultValue: false, description: 'Использовать динамическое обновление', name: 'dynamicUpdate')
        booleanParam(defaultValue: false, description: 'Оставить блокировку ИБ', name: 'keepLockIB')
        string(defaultValue: "${env.pausePredBuild}", description: 'Пауза после отправки уведомления и запуском сценария (в секундах). Позволяет переопределить паузу из настроек по умолчанию (5 мин), если она включена в сценарии. (0 - оставить по умолчанию)', name: 'pausePredBuild')        
        string(defaultValue: "1", description: 'Начать с указанной позиции. Использовать, если при обновлении вышла ошибка и нужно после исправления продолжить сценарий', name: 'startFromPosition')        
        string(defaultValue: "${env.baseID}", description: 'Идентификатор базы. Используется в сценариях с постфиксом base_ID', name: 'baseID')
        string(defaultValue: "${env.platformID}", description: 'Идентификатор используемой платформы для базы base_ID. Используется в сценариях с постфиксом base_ID', name: 'platformID')
        booleanParam(defaultValue: "${env.sendMessageStatusJob}", description: 'Отправлять сообщение о статусе задания Jenkins', name: 'sendMessageStatusJob')
        booleanParam(defaultValue: "${env.debug}", description: 'Отладка', name: 'debug')   
    }
   
    agent {        
        label "${(env.jenkinsAgent == null || env.jenkinsAgent == 'null') ? "master" : env.jenkinsAgent}"
    }
    environment {
        LOGOS_LEVEL = logos_level()                
        SYNC_REPO_BUILD_USER = build_user()
        SYNC_REPO_UPDATE_DYNAMIC = dynamicUpdate()
        SYNC_REPO_KEEP_LOCK_IB = keepLockIB()
        SYNC_REPO_BACKGROUND = true
        SYNC_REPO_USEPOWERSHELL = true
        SYNC_REPO_PAUSE_PRED_BUILD = pausePredBuildToInt()
        SYNC_REPO_BUILD_STARTFROMPOSITION = startFromPositionToInt()
        SYNC_REPO_BUILD_LISTMETADATA = "${listMetadataBuild}"
        SYNC_REPO_BUILD_LISTMETADATA_INCLUDECHILDOBJECTS = includeChildObjects()
        BASE_ID = "${baseID}"
        PLATFORM_ID = "${platformID}"
                }                                
    options {
        timeout(time: 8, unit: 'HOURS') 
        buildDiscarder(logRotator(numToKeepStr:'10'))
    }
    stages {
        stage("Pre-Build") {
             steps {
                timestamps {
                    script {
                     returnCode = utils.cmd("oscript init.os")
                     if (returnCode != 0) {
                        utils.raiseError("Возникла ошибка при запуске скрипта init.os")
                        }                     
                    }
                }
            }
        }
        stage("Запуск") {
             steps {
                timestamps {
                    script {
                 
                     sendTelegramMessage("▶️ Jenkins is start ${JOB_NAME} - ${command_file}")

                     command_folder = command_file != "debug" ? "bat" : "tests"                     
                     
                     returnCode = utils.cmd("cd ${command_folder} \n ${command_file}.bat")
                     if (returnCode != 0) {
                       
                        def pathFileErrors = "${WORKSPACE}/var/errors/error_0.log"
                        def exists = fileExists pathFileErrors
                        if (exists) {
                           message = readFile pathFileErrors
                         } else {
                            message = "Возникла ошибка при запуске"
                        }
                        utils.raiseError(message)

                       }                     
                    }
                }
            }
        }
    }
    post {
        success{
            script {
                sendTelegramMessage("✅ ${JOB_NAME} - ${command_file} is Success")              
                } 
        }
        unstable{
            script {
                sendTelegramMessage("⚠️ ${JOB_NAME} - ${command_file} is Alarm")                
                } 
        }
        failure{
            script {
                sendTelegramMessage("🆘 ${JOB_NAME} - ${command_file} is Failure")
                } 
        }       
    }  
    
}

def build_user() {
 
    wrap([$class: 'BuildUser']) {
        user = "${BUILD_USER}"
    }
    
    if (user == "") {
        user = "Jenkins"
    }

    return user
}

def logos_level() { 
 
    return params.debug ? "DEBUG" : ""

}

def dynamicUpdate() { 
 
    return params.dynamicUpdate

}

def includeChildObjects() { 
 
    return params.includeChildObjects

}

def keepLockIB() { 
 
    return params.keepLockIB

}

def pausePredBuildToInt() { 

    value = 0
    value = params.pausePredBuild
    return value   

}

def startFromPositionToInt() { 

    value = 1
    value = params.startFromPosition
    return value   

}

def sendTelegramMessage(message) { 

   if (params.sendMessageStatusJob) {
        def telegram = new Telegram()
        telegram.sendTelegramMessage(message)
    }

}
