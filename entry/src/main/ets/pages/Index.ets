import { IndexCityListView } from 'index-listview/Index'
@Entry
@Component
struct Index {
  build() {
    Column() {
      IndexCityListView()
    }
    .width('100%')
    .height('100%')
  }
}

