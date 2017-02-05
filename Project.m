function varargout = Project(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Project_OpeningFcn, ...
                   'gui_OutputFcn',  @Project_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Project is made visible.
function Project_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Project wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Project_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% --------------------------------------------------------------------
function File_Menu_Callback(hObject, eventdata, handles)

function Input_Image_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile({'*.tif';'*.gif';'*.jpg'}, 'Please Select an Image ');
Path =fullfile(pathname,filename);
Image = imread(Path);
axes(handles.axes1);
imshow(Image);

handles.Image = Image;
guidata(hObject,handles);

% --------------------------------------------------------------------
function Exit_Callback(hObject, eventdata, handles)
close all;
function Verify_Callback(hObject, eventdata, handles)
Image = handles.Image;
% Obtain Connection to Database
    Conn = database('dip_project', 'root', 'Dragunov', 'Vendor', 'MYSQL', 'Server', 'localhost', 'PortNumber', 3306);
    Q1 = 'SELECT FingerPrint_Image FROM fingerprints';
    Res = exec(Conn,Q1)
    Object = fetch(Res);
    flag = 0;
    for i=1:size(Object.Data,1)
        P = Object.Data(i);
        P = P{1};
        temp = imread(P);
        [ Ati, Abi, Aoi] = Minutiae_Extraction(Image);
        [ Bti, Bbi, Boi] = Minutiae_Extraction(temp);
        C = Minutiae_Match(Aoi,Boi);
        if (C)
%                 figure;imshow(Ati);title('Thin Image');
%                 figure;imshow(Abi);title('Binary Image');
%                 figure;imshow(Aoi);title('Minutiae Image');
                
                Q1 = sprintf('SELECT User_ID FROM fingerprints WHERE FingerPrint_Image like "%s"',P);
                Q1_Result = exec(Conn, Q1);
                Content = fetch(Q1_Result)
                User_ID = Content.Data;
                User_ID = User_ID{1};
                
                Q2 = sprintf('SELECT * FROM user WHERE User_ID =%d',User_ID);
                Q2_Result = exec(Conn, Q2);
                Fetch_Result = fetch(Q2_Result);
                
                % User Info
                User_Info = Fetch_Result.Data;
                
                Name = User_Info(2);
                Email = User_Info(3);
                CNIC = User_Info(4);
                Pic = User_Info(5);
                
                % Convert to Srings
                Name = Name{1};
                Email =Email{1};
                CNIC = CNIC{1};
                Pic = Pic{1};
                
                axes(handles.axes2);
                User_Image = imread(Pic);
                imshow(User_Image);
                set(handles.UName,'String',Name);
                set(handles.email,'String',Email);
                set(handles.cnic,'String',CNIC);
                flag = 1;
                break;
     
      end
    end
  if (flag)
      msgbox('Match Found.....!','Verification Completed');
  else
      msgbox('No Match Found....!','ERROR','error');
  end
        


% --------------------------------------------------------------------
function About_Menu_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Help_Menu_Callback(hObject, eventdata, handles)

function Help_Callback(hObject, eventdata, handles)
msgbox({'Habib Ullah , Alam Khan , M.Suliman' 'Unixian@outlook.com'},'About','Help');
function About_Callback(hObject, eventdata, handles)
msgbox({'Habib Ullah , Alam Khan , M.Suliman' 'Unixian@outlook.com'},'About','Help');
function Website_Callback(hObject, eventdata, handles)
msgbox({'Habib Ullah , Alam Khan , M.Suliman' 'Unixian@outlook.com'},'About','Help');


% --- Executes on button press in Admin_Switch.
function Admin_Switch_Callback(hObject, eventdata, handles)
set(handles.Verify,'Visible','off');
set(handles.axes1,'Visible','off');
set(handles.axes2,'Visible','off');
set(handles.Panel,'Visible','off');
set(handles.AdminPanel,'Visible','on');

set(handles.Admin_Switch,'Visible','off');
set(handles.Admin_Logout,'Visible','on');


function Name_Input_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function Name_Input_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Email_Input_Callback(hObject, eventdata, handles)
% hObject    handle to Email_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Email_Input as text
%        str2double(get(hObject,'String')) returns contents of Email_Input as a double


% --- Executes during object creation, after setting all properties.
function Email_Input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Email_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CNIC_Input_Callback(hObject, eventdata, handles)
% hObject    handle to CNIC_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CNIC_Input as text
%        str2double(get(hObject,'String')) returns contents of CNIC_Input as a double


% --- Executes during object creation, after setting all properties.
function CNIC_Input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CNIC_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Picture_Input_Callback(hObject, eventdata, handles)
% hObject    handle to Picture_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Picture_Input as text
%        str2double(get(hObject,'String')) returns contents of Picture_Input as a double


% --- Executes during object creation, after setting all properties.
function Picture_Input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Picture_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FingerPrint_Input_Callback(hObject, eventdata, handles)
% hObject    handle to FingerPrint_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FingerPrint_Input as text
%        str2double(get(hObject,'String')) returns contents of FingerPrint_Input as a double


% --- Executes during object creation, after setting all properties.
function FingerPrint_Input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FingerPrint_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Picture_Browse.
function Picture_Browse_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile({'*.tif';'*.gif';'*.jpg'}, 'Please Select an Image ');
Picture_Path =fullfile(pathname,filename);

Picture_Path = strsplit(Picture_Path,'\');
% Picture_Path = fullfile(Picture_Path(6),'\',Picture_Path(7));
Picture_Path = Picture_Path(6);
handles.Picture_Path = Picture_Path;
guidata(hObject,handles);
set(handles.Picture_Input, 'String',Picture_Path);



% --- Executes on button press in Finger_Browse.
function Finger_Browse_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile({'*.tif';'*.gif';'*.jpg'}, 'Please Select an Image ');
FingerPrint_Path =fullfile(pathname,filename);

FingerPrint_Path = strsplit(FingerPrint_Path,'\');
FingerPrint_Path = FingerPrint_Path(6);
handles.FingerPrint_Path = FingerPrint_Path;
guidata(hObject,handles);
set(handles.FingerPrint_Input, 'String',FingerPrint_Path);





% --- Executes on button press in AddUser.
function AddUser_Callback(hObject, eventdata, handles)

User_ID = get(handles.User_ID_Input,'String');
User_ID = str2double(User_ID);

Name = get(handles.Name_Input,'String')
Email = get(handles.Email_Input,'String')
CNIC = get(handles.CNIC_Input,'String')
Picture_Path = handles.Picture_Path;
Picture_Path = Picture_Path{1}
FingerPrint_Path = handles.FingerPrint_Path;
FingerPrint_Path = FingerPrint_Path{1}

% Obtain Connection to Database
    Conn = database('dip_project', 'root', 'Dragunov', 'Vendor', 'MYSQL', 'Server', 'localhost', 'PortNumber', 3306);
    Q1 = sprintf('INSERT INTO user(User_ID, Name,Email,CNIC,Picture) VALUES(%d,"%s","%s","%s","%s")',User_ID, Name, Email, CNIC, Picture_Path);
    Q2 = sprintf('INSERT INTO fingerprints (User_ID, FingerPrint_Image) VALUES(%d,"%s")',User_ID,FingerPrint_Path );
    R1 = exec(Conn,Q1)
    R2 = exec(Conn,Q2)



function User_ID_Input_Callback(hObject, eventdata, handles)
function User_ID_Input_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Admin_Logout.
function Admin_Logout_Callback(hObject, eventdata, handles)
set(handles.Verify,'Visible','on');
set(handles.axes1,'Visible','on');
set(handles.axes2,'Visible','on');
set(handles.Panel,'Visible','on');
set(handles.AdminPanel,'Visible','off');
set(handles.Admin_Logout,'Visible','off');
set(handles.Admin_Switch,'Visible','on');
