// LoginDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Login.h"
#include "LoginDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

// CLoginDlg dialog

CLoginDlg::CLoginDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CLoginDlg::IDD, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CLoginDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Text(pDX, IDC_TEAM_A, m_strTeamA);
	for (int i=0;i<5;i++)
		DDX_Text(pDX, IDC_NAME_0+i, m_strTeamANames[i]);
	DDX_Text(pDX, IDC_TEAM_B, m_strTeamB);
	for (int i=0;i<5;i++)
		DDX_Text(pDX, IDC_NAME_6+i, m_strTeamBNames[i]);
}

BEGIN_MESSAGE_MAP(CLoginDlg, CDialog)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_WM_TIMER()
	//}}AFX_MSG_MAP
	//ON_BN_CLICKED(IDOK, &CLoginDlg::OnBnClickedOk)
	ON_BN_CLICKED(IDCANCEL, &CLoginDlg::OnBnClickedCancel)
	ON_BN_CLICKED(IDC_SELECT_TEAM, &CLoginDlg::OnBnClickedSelectTeam)
	ON_BN_CLICKED(ID_CLEAR, &CLoginDlg::OnBnClickedClear)
	ON_BN_CLICKED(ID_SUBMIT, &CLoginDlg::OnBnClickedSubmit)
END_MESSAGE_MAP()


// CLoginDlg message handlers

BOOL CLoginDlg::OnInitDialog()
{
	CDialog::OnInitDialog();
	CDialog::SetWindowText(TEXT("参赛选手信息录入系统"));

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	SetDlgItemText(IDC_SELECT_TEAM, TEXT("组队模式"));
	SetDlgItemText(ID_SUBMIT, TEXT("上传信息"));
	SetDlgItemText(ID_CLEAR, TEXT("清零"));
	SetDlgItemText(IDC_STATIC_A,TEXT("左组"));
	SetDlgItemText(IDC_STATIC_B,TEXT("右组"));
	SetDlgItemText(IDC_STATIC_LOG,TEXT("服务器信息确认"));

	team_mode = FALSE;
	m_checkbox.SubclassDlgItem(IDC_SELECT_TEAM, this);
	m_ctrlTeamA.SubclassDlgItem(IDC_TEAM_A, this);
	m_ctrlTeamB.SubclassDlgItem(IDC_TEAM_B, this);
	m_ctrlTeamA.ShowWindow(SW_HIDE);
	m_ctrlTeamB.ShowWindow(SW_HIDE);

	HWND clear;
	GetDlgItem(ID_CLEAR, &clear);
	::ShowWindow(clear, SW_HIDE);

	FILE* fp = fopen("scoreboard.ip","r");
	if (fp == NULL)
	{
		MessageBox(TEXT("配置文件无法找到"));
		return FALSE;
	}
	char ip[40];
	fscanf(fp, "%s", ip);
 
	sender.setup(ip, 3333);
	receiver.setup(3334);

	SetTimer(777,30, NULL);

	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CLoginDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
// 		CPaintDC dc(&m_ctrlTeamA);
// 		dc.Ellipse(&CRect(10,10,40,40));
	}
}

afx_msg void CLoginDlg::OnTimer(UINT_PTR nIDEvent)
{
	// check for waiting messages
	while( receiver.hasWaitingMessages() )
	{
		// get the next message
		ofxOscMessage m;
		receiver.getNextMessage( &m );

		// check for mouse moved message
		if ( m.getAddress() == "/team" )
		{ 
			CString A = TEXT("[团队赛]\n");
			A += m.getArgAsString(0).c_str();
			A += TEXT("  vs  ");
			A += m.getArgAsString(1).c_str();
			SetLog(A);
		}
		// check for mouse button message
		else if ( m.getAddress() == "/people" )
		{
			CString A = TEXT("[个人赛]\n");
			for (int i=0;i<5;i++)
			{
				A += m.getArgAsString(i).c_str();
				A += TEXT("  ");
			}
			A += TEXT("  vs  ");
			for (int i=5;i<10;i++)
			{
				A += m.getArgAsString(i).c_str();
				A += TEXT("  ");
			} 
			SetLog(A);
		}
	}
}

// The system calls this function to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CLoginDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}


void CLoginDlg::OnBnClickedCancel()
{
	// TODO: Add your control notification handler code here
	if (MessageBox(TEXT(""),TEXT("是否确定退出？"),MB_YESNO) == IDYES)
		OnCancel();
}

void CLoginDlg::OnBnClickedSelectTeam()
{
	team_mode = m_checkbox.GetCheck();
	m_ctrlTeamA.ShowWindow(team_mode);
	m_ctrlTeamB.ShowWindow(team_mode);
}

void CLoginDlg::OnBnClickedClear()
{
	return;
	m_strTeamA = "";
	m_strTeamB = "";
	for (int i=0;i<6;i++)
		m_strTeamANames[i] = "";
	for (int i=0;i<6;i++)
		m_strTeamBNames[i] = "";
	CWnd::UpdateData(FALSE);
	SetLog(TEXT(""));
}

void CLoginDlg::OnBnClickedSubmit()
{
	CWnd::UpdateData(TRUE);

	SetLog(TEXT("等待服务器响应")); 
#if 1
	{
		ofxOscMessage m;
		if (team_mode)
		{
			m.setAddress("/team");
			m.addStringArg(m_strTeamA.GetBuffer());
			m.addStringArg(m_strTeamB.GetBuffer());
		}
		else
		{
			m.setAddress("/people");
			for (int i=0;i<5;i++)
				m.addStringArg(m_strTeamANames[i].GetBuffer());
			for (int i=0;i<5;i++)
				m.addStringArg(m_strTeamBNames[i].GetBuffer());
		}
		sender.sendMessage(m); 
	}
#endif
	{
		ofxOscMessage m; 
		if (team_mode)
		{
			m.setAddress("/team_CN");
			addString(m, m_strTeamA);
			addString(m, m_strTeamB);
		}
		else
		{
			m.setAddress("/people_CN");
			for (int i=0;i<5;i++)
				addString(m, m_strTeamANames[i]);
			for (int i=0;i<5;i++)
				addString(m, m_strTeamBNames[i]);
		}
		sender.sendMessage(m); 
	}
}

void CLoginDlg::SetLog( CString text)
{
	SetDlgItemText(IDC_LOG, text);
}