class profile::iis {

  $iis_features = [
    'Web-WebServer',
    'Web-Asp-Net45',
  ]

  windowsfeature{ $iis_features:
    ensure => present,
  } ~>

  # Remove default binding by removing default website
  # (so it can be used by something else)
  dsc_xwebsite{'Default Web Site':
    dsc_ensure       => 'Absent',
    dsc_name         => 'Default Web Site',
    dsc_applicationpool => 'DefaultAppPool',
  }

  file{'C:\testsite':
    ensure => 'directory'
  }

  file{'C:\testsite\index.html':
    ensure  => 'file'
    content => '<h1>Hello World</h1>'
  }

  dsc_xwebsite{'NewWebsite':
    dsc_ensure       => 'Present'
    dsc_state        => 'Started'
    dsc_name         => 'TestSite'
    dsc_physicalpath => 'C:\testsite'
    dsc_bindinginfo  => MSFT_xWebBindingInformation {
      Protocol => 'HTTP'
      Port     => '80'
    }
  }
}
