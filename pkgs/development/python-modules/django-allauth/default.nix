{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  python,

  # build-system
  setuptools,

  # build-time dependencies
  gettext,

  # dependencies
  django,
  python3-openid,
  requests,
  requests-oauthlib,
  pyjwt,

  # optional-dependencies
  python3-saml,
  qrcode,

  # tests
  pillow,
  pytestCheckHook,
  pytest-django,

  # passthru tests
  dj-rest-auth,
}:

buildPythonPackage rec {
  pname = "django-allauth";
  version = "0.61.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pennersr";
    repo = "django-allauth";
    tag = version;
    hash = "sha256-C9SYlL1yMnSb+Zpi2opvDw1stxAHuI9/XKHyvkM36Cg=";
  };

  nativeBuildInputs = [
    gettext
    setuptools
  ];

  propagatedBuildInputs = [
    django
    pyjwt
    python3-openid
    requests
    requests-oauthlib
  ] ++ pyjwt.optional-dependencies.crypto;

  preBuild = "${python.interpreter} -m django compilemessages";

  optional-dependencies = {
    saml = [ python3-saml ];
    mfa = [ qrcode ];
  };

  pythonImportsCheck = [ "allauth" ];

  nativeCheckInputs = [
    pillow
    pytestCheckHook
    pytest-django
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  disabledTests = [
    # Tests require network access
    "test_login"
  ];

  passthru.tests = {
    inherit dj-rest-auth;
  };

  meta = with lib; {
    changelog = "https://github.com/pennersr/django-allauth/blob/${version}/ChangeLog.rst";
    description = "Integrated set of Django applications addressing authentication, registration, account management as well as 3rd party (social) account authentication";
    downloadPage = "https://github.com/pennersr/django-allauth";
    homepage = "https://www.intenct.nl/projects/django-allauth";
    license = licenses.mit;
    maintainers = with maintainers; [ derdennisop ];
  };
}
