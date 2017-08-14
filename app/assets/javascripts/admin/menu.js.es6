class MenuConstructor {
  static get tagTemplate() {
    return _.template($('#tag-template').text());
  }

  static get tagGroupTemplate() {
    return _.template($('#tag-group-template').text());
  }

  constructor(container) {
    this.menu = container;

    this.tags = this.menu.find('.left-side .tags');
    this.tagGroups = this.menu.find('.right-side .tag-groups');

    this.tagAddButton = this.menu.find('.menu-tag-add-js');
    this.tagGroupAddButton = this.menu.find('.menu-tag-group-add-js');

    this._bindHandlers();
    this._renderPersisted();
    this._initializeSorting();
  }

  addTag(event, object) {
    let tag, tagSelect;

    if (object) {
      tag = $(MenuConstructor.tagTemplate({ position: object.position }));
    } else {
      let count = this.tags.find('.tag').size();
      tag = $(MenuConstructor.tagTemplate({ position: count + 1 }));
    }

    this.tags.append(tag);
    tagSelect = tag.find('select').selectize();

    if (object) {
      tagSelect[0].selectize.setValue(object.tag_id);
    }

    tag.removeClass('hidden');
  }

  removeTag(event) {
    let tag = $(event.target).closest('.tag');
    tag.remove();
  }

  addTagGroup(event, object) {
    let position, tagGroup, tagGroupSelects;

    if (object) {
      position = object.position;
    } else {
      let count = this.tagGroups.find('.tag-group').size();
      position = count + 1;
    }

    tagGroup = $(MenuConstructor.tagGroupTemplate({ position: position }));
    this.tagGroups.append(tagGroup)

    let options = {
      plugins: ['remove_button', 'drag_drop']
    };

    tagGroupSelects = tagGroup.find('select').selectize(options);

    if (object) {
      let single = tagGroupSelects[0].selectize;
      let multiple = tagGroupSelects[1].selectize;

      single.setValue(object.tag_id);
      multiple.setValue(object.tag_ids);
    }

    tagGroup.removeClass('hidden');
  }

  removeTagGroup(event) {
    let tagGroup = $(event.target).closest('.tag-group');
    tagGroup.remove();
  }

  _bindHandlers() {
    this.tagAddButton.on('click', $.proxy(this.addTag, this));
    this.tagGroupAddButton.on('click', $.proxy(this.addTagGroup, this));

    this.tags.on('click', '.menu-tag-remove-js', $.proxy(this.removeTag, this));
    this.tagGroups.on('click', '.menu-tag-group-remove-js', $.proxy(this.removeTagGroup, this));
  }

  _renderPersisted() {
    let tags = this.menu.data('tags');
    let tagGroups = this.menu.data('tagGroups');

    $.each(tags, (index, tag) => { this.addTag(null, tag) });
    $.each(tagGroups, (index, tagGroup) => { this.addTagGroup(null, tagGroup) });
  }

  _initializeSorting() {
    let configFor = (className, collectionName) => {
      return {
        items: className,
        cursor: 'move',
        containtment: 'parent',
        axis: 'y',
        update: (event, ui) => {
          this[collectionName].find(className).each((index, element) => {
            $(element).find('input[type="hidden"]').val(index + 1);
          });
        }
      };
    };

    this.tags.sortable(configFor('.tag', 'tags'));
    this.tagGroups.sortable(configFor('.tag-group', 'tagGroups'));
  }
}

$(() => new MenuConstructor($('.menu-constructor')));
