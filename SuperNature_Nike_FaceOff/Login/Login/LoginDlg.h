// LoginDlg.h : header file
//

#pragma once


// CLoginDlg dialog
class CLoginDlg : public CDialog
{
// Construction
public:
	CLoginDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	enum { IDD = IDD_LOGIN_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support

	void SetLog(CString);


// Implementation
protected:
	//network
	ofxOscSender sender;
	ofxOscReceiver receiver;

	HICON m_hIcon;
	CString m_strTeamA, m_strTeamB;
	CString m_strTeamANames[5];
	CString m_strTeamBNames[5];
	// Generated message map functions
	CButton m_checkbox;
	CEdit m_ctrlTeamA,m_ctrlTeamB;
	int team_mode;
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnTimer(UINT_PTR nIDEvent);
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedOk();
	afx_msg void OnBnClickedCancel();
	afx_msg void OnBnClickedSelectTeam();
	afx_msg void OnBnClickedOk2();
	afx_msg void OnBnClickedClear();
	afx_msg void OnBnClickedSubmit();

	int addString(ofxOscMessage &m, CString& str) 
	{
		int length = str.GetLength();
		m.addIntArg(length);
		for (int i=0;i<length;i++)
			m.addIntArg(str.GetBuffer()[i]);	
		return length;
	}
};
