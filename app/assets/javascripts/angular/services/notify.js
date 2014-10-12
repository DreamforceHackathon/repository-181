APP.service("Notify", function() {
  var notify = {};

  notify.custom = function(options) {
    if (!options.text) { options.text = ""; }
    return new PNotify(options);
  };

  notify.success = function (title, text) {
    notify.custom({
      title: title,
      text:  text,
      icon:  'fa fa-thumbs-up',
      type:  'success'
    });
  };

  notify.error = function (title, text) {
    notify.custom({
      title: title,
      text:  text,
      icon:  'fa fa-thumbs-down',
      type:  'error'
    });
  };

  return notify;
});

PNotify.prototype.options.delay = 3000;
