import React from "react"
import PropTypes from "prop-types"
import NewsItem from './NewsItem/NewsItem'
import styles from './News.module.scss'
import { Pagination } from 'semantic-ui-react'

class News extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      news: [],
      page: [],
      pages: []
    };
  }

  componentDidMount() {
    fetch('/api/v1/news')
      .then((response) => {return response.json()})
      .then((data) => {this.setState({
        news: data.news,
        page: data.current_page,
        pages: data.total_pages
      }) });
  }

  handlePage = (e, {activePage}) => {
    let gotopage = { activePage }
    let pagenum = gotopage.activePage
    let pagestring = pagenum.toString()
    this.setState({
      loading:true
    })
    fetch('/api/v1/news/?page='+pagestring)
      .then((response) => {return response.json()})
      .then((data) => {this.setState({ 
        news: data.news
       }) });
  }

  render () {
    var news = this.state.news.map((news) => {
      return(
        <NewsItem attributes={news} />
      )
    })

    return (
      <div className={styles.itemsContainer}>
        {news}
        <div className={styles.pagination}>
          <Pagination
            onPageChange={this.handlePage}
            siblingRange='8'
            defaultActivePage={this.state.page}
            totalPages={this.state.pages}
          />
        </div>
      </div>
    )
  }
}

export default News
