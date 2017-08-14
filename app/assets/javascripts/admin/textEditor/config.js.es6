//= require admin/textEditor/filePickerCallback
//= require admin/textEditor/maxLength

function config(editor, maxLengthCounter) {
  let config = {
    selector: editor,
    resize: false,
    skin_url: '/assets/tinymce/skins/lightgray',
    statusbar: false,
    rel_list: [
        {title: 'None', value: ''},
        {title: 'Nofollow', value: 'nofollow'},
        {title: 'Noindex', value: 'noindex'},
        {title: 'Noindex Nofollow', value: 'noindex nofollow'}
    ],
    default_link_target: '_blank',
    anchor_top: false,
    anchor_bottom: false,
    link_title: false,
    // Подключаем нужные нам плагины
    plugins: 'placeholder link image',
    // Выставляем нужные нам элементы и в нужном нам порядке
    toolbar: 'bold italic underline | subscript superscript | link image',
    // Отключаем дополнительное меню
    menubar: false,
    // Элементы маленькие
    toolbar_items_size: 'small',
    // Включить поле заголовка в диалоговом окне Image
    image_title: true,
    // Включить автоматическую загрузку изображений, представленных Blob или данных URIs,
    automatic_uploads: true,
    // URL нашего обработчика загрузки (для более подробной информации проверить: https://www.tinymce.com/docs/configure/file-image-upload/#images_upload_url)
    // Images_upload_url: 'postAcceptor.php',
    // Здесь мы добавляем пользовательские filepicker только диалог изображения
    file_picker_types: 'image',
    // И вот наш подборщика пользовательских изображений
    file_picker_callback(cb, value, meta) {
      filePickerCallback(cb, value, meta);
    },
    // Колбек, действие после инициилизации редактора
    setup(ed) {
      ed.on('keyup', () => editorMaxLength(ed, maxLengthCounter));
    },
    init_instance_callback(ed) {
      editorMaxLength(ed, maxLengthCounter);
    }
  };

  return config;
}
