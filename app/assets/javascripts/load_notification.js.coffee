$ ->
  content = $('#list-notifications')
  viewMore = $('#view-more')

  isLoadingNextPage = false
  lastLoadAt = null
  minTimeBetweenPages = 1000
  loadNextPageAt = 1000

  waitedLongEnoughBetweenPages = ->
    return lastLoadAt == null || new Date() - lastLoadAt > minTimeBetweenPages

  approachingBottomOfPage = ->
    return document.documentElement.clientHeight +
      $(document).scrollTop() < document.body.offsetHeight - loadNextPageAt

  nextPage = ->
    url = viewMore.find('a').attr('href')

    return if isLoadingNextPage || !url

    viewMore.addClass('loading')
    isLoadingNextPage = true
    lastLoadAt = new Date()

    $.ajax
      url: url,
      method: 'GET',
      dataType: 'script',
      success: ->
        viewMore.removeClass('loading');
        isLoadingNextPage = false;
        lastLoadAt = new Date();

  $(window).scroll ->
    scrollHeight = $(document).height();
    scrollPosition = $(window).height() + $(window).scrollTop();
    url = $('#view-more').find('a').attr('href')
    if (scrollHeight - scrollPosition) / scrollHeight == 0 && url
      nextPage()
