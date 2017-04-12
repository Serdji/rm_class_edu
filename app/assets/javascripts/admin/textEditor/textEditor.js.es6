//= require admin/textEditor/config

// Русифицируем TinyMCE
//= require tinymceExtensions/langs/ru/ru

// Добавляем плагин математике
//= require tinymceExtensions/plugins/asciimath4/plugin

// Подключаем плагин плейсхолдера
//= require tinymceExtensions/plugins/placeholder/plugin

//= require tinymce/plugins/image/plugin
//= require tinymce/plugins/link/plugin

let maxLengthCounter = document.querySelector('span[data-max-length-counter="true"]');
tinymce.init(config('.js-text-editor', maxLengthCounter));
