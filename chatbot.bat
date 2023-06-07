@echo off

setlocal enabledelayedexpansion

REM Define the main window title
title Tick-Bot: Your Friendly Chat Companion

REM Create the chat log text file
echo. > chat_log.txt

REM Define the list of Tick-Bot's greetings
set "greetings=Hey there! Hello! Hi! Hey, how's it going? Greetings! Nice to see you!"

REM Define the list of Tick-Bot's conversation starters
set "conversation_starters=So, what's new with you? Got any exciting plans for the weekend? Tell me something funny that happened to you recently. Do you have any hobbies or interests you'd like to share?"

REM Define the list of Tick-Bot's responses
set "responses=That sounds interesting. Tell me more! I'm curious to know more. Wow, that's amazing! I never thought about it that way. You always have the best stories. I'm glad you shared that with me. That's quite fascinating! Thanks for telling me about that. I appreciate you sharing that with me. I'm enjoying our conversation. You have a unique perspective on things."

REM Define the list of Tick-Bot's responses to questions
set "question_answers=I'm sorry, I don't have the answer to that question. I'm not sure, but I can try to find some information for you. That's a great question! Unfortunately, I don't have the answer. I'm afraid I don't have the information you're looking for. Hmm, I'm not sure about that. Would you like me to search the internet for more details?"

REM Clear the chat log
echo Clear Chat
echo. > chat_log.txt

REM Function to save the chat log to a text file
:save_chat_log
set /p "file_path=Enter file path to save chat log (default: chat_log.txt): "
if "%file_path%"=="" set "file_path=chat_log.txt"
echo Saving chat log to "%file_path%"
copy /y nul "%file_path%"
for /f "delims=" %%A in (chat_log.txt) do (
    >>"%file_path%" echo %%A
)
echo Chat log saved successfully.
goto :eof

REM Function to handle file upload
:upload_file
set "button=%~1"
echo Please select a file to upload:
set "file_path="
set /p "file_path=File path: "
if defined file_path (
    setlocal disabledelayedexpansion
    set "file_path=!file_path:"=!"
    set "file_path=!file_path:'=!"
    if not exist "!file_path!" (
        echo File does not exist: "!file_path!"
    ) else (
        echo File uploaded successfully: "!file_path!"
        setlocal enabledelayedexpansion
        set "button_state=!button:_button=!"
        if "!button_state!"=="image_upload_" (
            set "button_state=image_upload"
        ) else if "!button_state!"=="data_upload_" (
            set "button_state=data_upload"
        ) else if "!button_state!"=="html_upload_" (
            set "button_state=html_upload"
        )
        set "!button_state!=disabled"
        endlocal
    )
)
goto :eof

REM Function to generate a response from Tick-Bot
:generate_response
set "user_input=%~1"
set "lowercase_input=!user_input:~0,1!!user_input:~1!"
set "lowercase_input=!lowercase_input:~0,1!!lowercase_input:~1!"
set /a "random_index=%random% %% 12"

REM Check if the user greeted Tick-Bot
echo %greetings% | findstr /i /c:"!lowercase_input!" >nul
if not errorlevel 1 (
    set "response=!greetings:%lowercase_input%=!"
    echo Bot: !response:~2!
    goto :eof
)

REM Check if the user wants to start a conversation
if "!lowercase_input!"=="let's start a topic" (
    echo Bot: !conversation_starters:~2!
    goto :eof
)
echo %conversation_starters% | findstr /i /c:"!lowercase_input!" >nul
if not errorlevel 1 (
    set "response=!conversation_starters:%lowercase_input%=!"
    echo Bot: !response:~2!
    goto :eof
)

REM Check if the user mentioned a topic Tick-Bot doesn't know about
echo !lowercase_input! | findstr /i /c:"topic" >nul
if not errorlevel 1 (
    set "topic=!user_input:*topic =!"
    set "topic=!topic:~0,-1!"
    if "!topic!"=="" (
        echo Bot: Hmm, that's an interesting topic. Could you tell me more about it?
    ) else (
        echo Bot: I've never heard of this '!topic!' before! Tell me more about it.
    )
    goto :eof
)

REM Check if the user asked a question
echo !lowercase_input! | findstr /c:"?" >nul
if not errorlevel 1 (
    echo Bot: !question_answers:~2!
    goto :eof
)

REM Check if the user provided a negative response
echo !lowercase_input! | findstr /i /c:"no" >nul
if not errorlevel 1 (
    echo Bot: I'm sorry if I said something wrong. Let's change the topic.
    goto :eof
)
echo !lowercase_input! | findstr /i /c:"not" >nul
if not errorlevel 1 (
    echo Bot: I'm sorry if I said something wrong. Let's change the topic.
    goto :eof
)
echo !lowercase_input! | findstr /i /c:"don't" >nul
if not errorlevel 1 (
    echo Bot: I'm sorry if I said something wrong. Let's change the topic.
    goto :eof
)
echo !lowercase_input! | findstr /i /c:"never" >nul
if not errorlevel 1 (
    echo Bot: I'm sorry if I said something wrong. Let's change the topic.
    goto :eof
)

REM Check if the user asked how Tick-Bot is doing
echo !lowercase_input! | findstr /i /c:"how" >nul
if not errorlevel 1 (
    echo !lowercase_input! | findstr /i /c:"you" >nul
    if not errorlevel 1 (
        echo Bot: I'm an AI, so I don't have feelings, but I'm here to chat with you!
        goto :eof
    )
)

REM Check if the user asked about the creator
echo !lowercase_input! | findstr /i /c:"who" >nul
if not errorlevel 1 (
    echo !lowercase_input! | findstr /i /c:"created" >nul
    if not errorlevel 1 (
        echo Bot: Tick Studios created me.
        goto :eof
    )
)

REM Check if the user asked who Tick Studios is
echo !lowercase_input! | findstr /i /c:"who" >nul
if not errorlevel 1 (
    echo !lowercase_input! | findstr /i /c:"tick studios" >nul
    if not errorlevel 1 (
        echo Bot: Tick Studios is a company that is developing the latest ways to help people and also comes up with the best technologies that are web-based. Tick Studios is also a company that develops writing-based software.
        goto :eof
    )
)

REM If none of the above conditions are met, generate a generic response
echo Bot: !responses:~%random_index%,1!
goto :eof

REM Function to extract the topic from user input
:extract_topic
set "user_input=%~1"
for /f "tokens=2" %%A in ("!user_input:*topic =!") do set "topic=%%A"
if defined topic echo !topic!
goto :eof

REM Function to check if the user provided a negative response
:is_negative_response
set "user_input=%~1"
set "negative_words=no not don't never"
for %%A in (!negative_words!) do (
    echo !user_input! | findstr /i /c:"%%A" >nul
    if not errorlevel 1 exit /b 1
)
exit /b 0

REM Function to handle the user's message
:handle_message
set "user_input=%~1"
echo User: !user_input!
call :generate_response "!user_input!"
goto :eof

REM Bind the Enter key to handle the user's message
echo Bot: !greetings:~%random_index%,1!
echo.
set /p "user_input=User: "
call :handle_message "!user_input!"
goto :eof
