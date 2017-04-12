(function() {
  window.ramblerToplineParams = {
    projectName: 'class', // Символьный код проекта, полный список ниже
    logoName: 'head', // Необязательный параметр. Нужен, когда utm-метки и лого должны различаться. Поумолчанию равен projectName. Если задан, то логотип будет отображаться только один - на главную.
    showLogo: false, // Показывать логотип проекта (default: true) если для проекта не предусмотрен лого в топлайне, то этот параметр бесполезен
    showLogoMobile: false, // Показывать логотип проекта в Мобильном топлайне (default: true)
    showUser: true, // Показывать блок пользователя (default: true)
    menuMailCounter: true, // Показывать счетчик писем у пункта 'Почта' в меню проектов (default: true)
    linksTargetBlank: true, // Открывать ссылки меню в новом окне/табе (default: false)
    fullWidth: false, // Резиновый топлайн, 100% ширины (default: false)
    fullWidthGap: 20, // Размер отступа резинового топлайна в пикселях, (default: 20)
    mobileTopline: { // Опции мобильного топлайна
      always: false, // Показывать независимо от брейпоинтов мобильный топлайн
      show: false, // Показывать мобильный топлайн на узких экранах (default: false)
      logoLinkMode: false, // Если true, то в сайдбаре не будет пункта меню 'Главная', а логотип будет вести на главную (default: false)
      desktopSwitcher: { // Опции переключателя на полную версию
        show: false, // Показывать ссылку на полную версию (default: false)
        url: '', // Ссылка на полную версию (default: '')
      },
      menuApplications: { // Меню мобильных приложений
        show: false, // Показывать данный блок (default: false)
        apps: { // Настройки ссылок на мобильные приложения
          mail: { // Настройка ссылки на Почту
            url: '' // Ссылка на приложение (default: '')
          },
          news: { // Настройка ссылки на Новости
            url: '' // Ссылка на приложение (default: '')
          },
          horoscopes: { // Настройка ссылки на Гороскопы
            url: '' // Ссылка на приложение (default: '')
          },
          dating: { // Настройка ссылки на Знакомства
            url: '' // Ссылка на приложение (default: '')
          }
        }
      }
    },
    customLinks: [ // Дополнительные ссылки в дроп-даун блоке пользователя (default: [] - без ссылок)
      { 'title': 'Новости', 'href': 'http://news.rambler.ru' },
      // {} ...
    ],
    regParam: encodeURIComponent(`//id.rambler.ru/account/external-registration?back=${window.location.href}`), // Добавит параметр registration_link со значением //example.com к ссылке на авторизационный фрейм(default: ')
    enableAdBlock: false, // Включить скипт проверки подписки Rambler AdBlock
    theme: { // Кастомизировать расцветку топлайна
      logoColor: null, // Цвет логотипа, иконки логина, иконки бургера\крестика (default: #315efb)
      fontColor: null, // Общий цвет текста и ссылок в топлайна (default: #494e59)
      fontColorHover: null, // Цвет для hover-ссылок (default: #315efb)
      backgroundColor: null, // Цвет фона топлайна, дропдауна и юзер-дропдауна (default: #fff)
      borderColor: null, // Цвет бордера топлайна и дропдауна (default: #e8e8e8)
      iconsColor: null, // Цвет икононки 'еще проекты' (default: #b0b0b0) и фона нотификации 'непрочитанных писем' (default: #315efb)
      dropDownBorderColor: null, // Цвет бордера в юзер-дропдауне (default: #edeef3)
      dropDownFooterColor: null, // Цвет текста и ссылок в юзер-дропдауне (default: rgba(#262626, 0.6))
      dropDownFooterColorHover: null, // Цвет hover-ссылок в юзер-дропдауне (default: rgba(#262626, 1))
      dropDownMailLinkColor: null, // Цвет ссылки на почту в юзер-дропдауне (default: #2d57ff)
      dropDownMailLinkColorHover: null, // Цвет hover-ссылки на почту в юзер-дропдауне (default: #284ee5)
      dropDownFooterBackground: null // Фон нижней части юзер-дропдауна (default: #f6f7fa)
    },
    testing: false, // Активация панели тестирования параметров топлайна (default: false)
    breakpoints: { // брейкпоинты для переключения топлайна с шириной экрана
      viewports: { // ширина экрана (ниже дефолтные значения)
        large: 1279,
        medium: 920,
        small: 900
      },
      widths: { // ширина .rambler-topline__inner
        large: 1200,
        medium: 900,
        small: 900
      }
    }
  };
})();
